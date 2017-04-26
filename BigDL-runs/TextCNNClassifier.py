from __future__ import print_function
import sys
from random import random
from operator import add
from pyspark.sql import SparkSession

spark = SparkSession.builder\
  .master("yarn")\
  .appName("TextClassifier")\
  .getOrCreate()

sc=spark.sparkContext  
sc.addPyFile("/home/cdsw/dist/lib/bigdl-0.2.0-SNAPSHOT-python-api.zip")
  
import itertools
import re
from sklearn.metrics import confusion_matrix
from sklearn.metrics import accuracy_score
import matplotlib.pyplot as plt
%matplotlib inline
import seaborn as sn
import pandas as pd
from wordcloud import WordCloud
import random as rd
import datetime as dt

from dataset import news20
from nn.layer import *
from nn.criterion import *
from optim import *
from optim.optimizer import *
from util.common import *
from util.common import Sample
import util.common

init_engine()

#Prepare the Data
batch_size = 128
embedding_dim = 50
sequence_len = 50
max_words = 1000 
training_split = 0.8

#Load the data
texts = news20.get_news20('/tmp/news20data')
w2v = news20.get_glove_w2v(dim=embedding_dim)
len(texts),len(w2v)

##Show the wordcloud
rand_idx=rd.randrange(0, len(texts))
wordcloud = WordCloud(max_font_size=40,background_color="white").generate(texts[rand_idx][0])
print( "the newsgroup of the text is %d"%(texts[rand_idx][1]))
plt.imshow(wordcloud)
plt.axis("off");


##Use spark to launch do word analysis
data_rdd = sc.parallelize(texts, 2)

# break the text corpus into tokens (words)
def text_to_words(review_text):
    letters_only = re.sub("[^a-zA-Z]", " ", review_text)
    words = letters_only.lower().split()
    return words
# calcualte the frequency of words in each text corpus, sort by frequency, and assign an id to each word
def analyze_texts(data_rdd):
    return data_rdd.flatMap(lambda (text, label): text_to_words(text)) \
        .map(lambda word: (word, 1)).reduceByKey(lambda a, b: a + b) \
        .sortBy(lambda (w, c): - c).zipWithIndex() \
        .map(lambda ((w, c), i): (w, (i + 1, c))).collect()
        
word_to_ic = analyze_texts(data_rdd)
# take the top "max_words" most frequent words while remove the top 10 ( may not be meaningful,e.g. "of","the")
#broad case the word count info 
word_to_ic = dict(word_to_ic[10: max_words])
bword_to_ic = sc.broadcast(word_to_ic)

#prepare and broadcast word embeddings 
filtered_w2v = {w: v for w, v in w2v.items() if w in word_to_ic}
bfiltered_w2v = sc.broadcast(filtered_w2v)


#Prepare the train/val dataset
def prepare_samples(data_rdd,
                    sequence_len,
                    embedding_dim,
                    bword_to_ic,
                    bfiltered_w2v):
    print ("preparing samples with embedding_dim = %s, sequence_len=%s"%(embedding_dim,sequence_len))
    def pad(l, fill_value, width):
        """
        pad the embedding to required length
        pad([1, 2, 3, 4, 5], 0, 6)
        """
        if len(l) >= width:
            return l[0: width]
        else:
            l.extend([fill_value] * (width - len(l)))
            return l
    def to_vec(token, b_w2v, embedding_dim):
        """
        word to vec
        """
        if token in b_w2v:
            return b_w2v[token]
        else:
            return pad([], 0, embedding_dim)  
    def to_sample(vectors, label, embedding_dim,sequence_len):
        """
        assemble the features (embeddings of words in each text sample) and label into samples
        """
        flatten_features = list(itertools.chain(*vectors)) # flatten nested list
        features = np.array(flatten_features, dtype='float').reshape(
            [sequence_len, embedding_dim]).transpose(1, 0)
        return Sample.from_ndarray(features, np.array(label))
    
    tokens_rdd = data_rdd.map(lambda (text, label):
                              ([w for w in text_to_words(text) if
                                w in bword_to_ic.value], label))
    padded_tokens_rdd = tokens_rdd.map(
        lambda (tokens, label): (pad(tokens, "##", sequence_len), label))

    vector_rdd = padded_tokens_rdd.map(lambda (tokens, label):
                                       ([to_vec(w, bfiltered_w2v.value,
                                                embedding_dim) for w in
                                         tokens], label))
    sample_rdd = vector_rdd.map(
        lambda (vectors, label): to_sample(vectors, label, embedding_dim,sequence_len))
    print('Generated Samples')
    return sample_rdd

sample_rdd = prepare_samples(data_rdd, sequence_len, embedding_dim,bword_to_ic,bfiltered_w2v)
#split train val sets
train_rdd, val_rdd = sample_rdd.randomSplit([training_split, 1-training_split])

#Define the model
def build_model(class_num=news20.CLASS_NUM,
                embedding_dim=embedding_dim,
                sequence_len=sequence_len):
    #print "building model with embedding_dim = %s, sequence_len=%s"%(embedding_dim,sequence_len)
    model = Sequential()
    model.add(Reshape([embedding_dim, 1, sequence_len]))
    model.add(SpatialConvolution(embedding_dim, 128, 5, 1).set_name('conv1'))
    model.add(ReLU())
    model.add(SpatialMaxPooling(5, 1, 5, 1))
    model.add(SpatialConvolution(128, 128, 5, 1).set_name('conv2'))
    model.add(ReLU())
    model.add(SpatialMaxPooling(5, 1, 5, 1))
    model.add(Reshape([128]))
    model.add(Linear(128, 100).set_name('fc1'))
    model.add(Linear(100, class_num).set_name('fc2'))
    model.add(LogSoftMax())
    return model

model = build_model()

#Optimizer

def create_optimizer(model,
                     app_name,
                     logdir='/tmp/bigdl_summaries',
                     batch_size=batch_size,
                     lr=0.01,
                     lrd=0.0002,
                     optim="Adagrad",
                     val=["Top1Accuracy","Loss"],
                     max_epoch=2):
    print ("optimize summary will be write to :",logdir+'/'+app_name)
    state = {"batchSize": batch_size,
         "learningRate": lr,
         "learningRateDecay": lrd}
    #configure optimizer
    optimizer = Optimizer(
        model=model,
        training_rdd=train_rdd,
        criterion=ClassNLLCriterion(),
        end_trigger=MaxEpoch(max_epoch),
        batch_size=batch_size,
        optim_method=optim,
        state=state)

    optimizer.set_validation(
        batch_size=batch_size,
        val_rdd=val_rdd,
        trigger=EveryEpoch(),
        val_method=val
    )
    train_summary = TrainSummary(log_dir=logdir, app_name=app_name)
    train_summary.set_summary_trigger("Parameters", SeveralIteration(50))
    val_summary = ValidationSummary(log_dir=logdir, app_name=app_name)
    optimizer.set_train_summary(train_summary)
    optimizer.set_val_summary(val_summary)
    return optimizer,train_summary,val_summary

print ('Start to train the model')
#configure optimizer
optimizer,train_summary,val_summary = create_optimizer(model,'adagrad-'+ dt.datetime.now().strftime("%Y%m%d-%H%M%S"))
trained_model = optimizer.optimize()
print ("Optimization Done.")

print('Print the evaluations')
predictions = trained_model.predict(val_rdd).collect()

def map_predict_label(l):
    return np.array(l).argmax()
def map_groundtruth_label(l):
    return l[0] - 1

y_pred = np.array([ map_predict_label(s) for s in predictions])

y_true = np.array([map_groundtruth_label(s.label) for s in val_rdd.collect()])

acc = accuracy_score(y_true, y_pred)
print ("The prediction accuracy is %.2f%%"%(acc*100))

print('Get the confusion matrix')
cm = confusion_matrix(y_true, y_pred)
cm.shape
df_cm = pd.DataFrame(cm)
plt.figure(figsize = (10,8))
sn.heatmap(df_cm, annot=True,fmt='d');
spark.stop()
