export BigDL_HOME=/home/cdsw/BigDL
export SPARK_HOME=/opt/cloudera/parcels/SPARK2/lib/spark2
export VERSION=0.2.0-SNAPSHOT
export MASTER=yarn
export BigDL_JAR_PATH=${BigDL_HOME}/dist/lib/bigdl-${VERSION}-jar-with-dependencies.jar


${SPARK_HOME}/bin/spark-submit \
--master ${MASTER} \
--deploy-mode cluster \
--executor-cores 1 \
--driver-class-path ${BigDL_JAR_PATH} \
--conf spark.executorEnv.DL_ENGINE_TYPE=mklblas \
--conf spark.executorEnv.MKL_DISABLE_FAST_MM=1 \
--conf spark.executorEnv.KMP_BLOCKTIME=0 \
--conf spark.executorEnv.OMP_WAIT_POLICY=passive \
--conf spark.executorEnv.OMP_NUM_THREADS=1 \
--conf spark.yarn.appMasterEnv.DL_ENGINE_TYPE=mklblas \
--conf spark.yarn.appMasterEnv.MKL_DISABLE_FAST_MM=1 \
--conf spark.yarn.appMasterEnv.KMP_BLOCKTIME=0 \
--conf spark.yarn.appMasterEnv.OMP_WAIT_POLICY=passive \
--conf spark.yarn.appMasterEnv.OMP_NUM_THREADS=1 \
--conf spark.shuffle.reduceLocality.enabled=false \
--conf spark.shuffle.blockTransferService=nio \
--conf spark.scheduler.minRegisteredResourcesRatio=1.0 \
--properties-file ${BigDL_HOME}/dist/conf/spark-bigdl.conf \
--num-executors 4 \
--files /home/cdsw/mnist/t10k-images-idx3-ubyte,/home/cdsw/mnist/t10k-labels-idx1-ubyte,/home/cdsw/mnist/train-images-idx3-ubyte,/home/cdsw/mnist/train-labels-idx1-ubyte \
--class com.intel.analytics.bigdl.models.lenet.Train \
${BigDL_JAR_PATH} \
-f . \
-e 1 \
-b 128
