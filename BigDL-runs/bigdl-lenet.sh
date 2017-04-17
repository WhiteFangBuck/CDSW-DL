./BigDL/dist/bin/bigdl.sh -- \
spark2-submit --master yarn-cluster --executor-cores 1 \
--properties-file ./dist/conf/spark-bigdl.conf \
--num-executors 4 \
--files /home/cdsw/mnist/t10k-images-idx3-ubyte,/home/cdsw/mnist/t10k-labels-idx1-ubyte,/home/cdsw/mnist/train-images-idx3-ubyte,/home/cdsw/mnist/train-labels-idx1-ubyte \
--driver-class-path ./dist/lib/bigdl-0.2.0-SNAPSHOT-jar-with-dependencies.jar \
--class com.intel.analytics.bigdl.models.lenet.Train \
./dist/lib/bigdl-0.2.0-SNAPSHOT-jar-with-dependencies.jar \
-f . \
-e 1 \
-b 128
