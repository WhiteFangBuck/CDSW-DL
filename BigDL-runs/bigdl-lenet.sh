
export BigDL_HOME=/home/cdsw
export SPARK_HOME=/opt/cloudera/parcels/SPARK2/lib/spark2
export BigDL_JAR_PATH=${BigDL_HOME}/dist/lib/bigdl-0.2.0-SNAPSHOT-jar-with-dependencies.jar


${SPARK_HOME}/bin/spark-submit \
--master yarn \
--deploy-mode cluster \
--executor-cores 1 \
--driver-class-path ${BigDL_JAR_PATH} \
--properties-file ${BigDL_HOME}/dist/conf/spark-bigdl.conf \
--num-executors 4 \
--files /home/cdsw/mnist/t10k-images-idx3-ubyte,/home/cdsw/mnist/t10k-labels-idx1-ubyte,/home/cdsw/mnist/train-images-idx3-ubyte,/home/cdsw/mnist/train-labels-idx1-ubyte \
--class com.intel.analytics.bigdl.models.lenet.Train \
${BigDL_JAR_PATH} \
-f . \
-e 1 \
-b 128
