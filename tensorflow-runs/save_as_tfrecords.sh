export SPARK_HOME=/opt/cloudera/parcels/SPARK2/lib/spark2
export PATH=$SPARK_HOME/bin:$PATH
export QUEUE=cpu



# save images and labels as CSV files
spark-submit \
--conf spark.yarn.appMasterEnv.PYSPARK_PYTHON=/usr/anaconda2/envs/py27/bin/python \
--conf spark.yarn.appMasterEnv.PYSPARK_DRIVER_PYTHON=/usr/anaconda2/envs/py27/bin/python \
--master yarn \
--deploy-mode client \
--queue ${QUEUE} \
--num-executors 4 \
--executor-memory 4G \
--archives mnist/mnist.zip#mnist \
--conf spark.jars=./jars/tensorflow-hadoop-1.0-SNAPSHOT-shaded-protobuf.jar \
--conf spark.executorEnv.LD_LIBRARY_PATH="/opt/cloudera/parcels/CDH/lib64:$JAVA_HOME/jre/lib/amd64/server" \
TensorFlowOnSpark/examples/mnist/mnist_data_setup.py \
--output mnist_1/tfr \
--format tfr
