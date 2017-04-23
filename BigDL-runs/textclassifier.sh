export BigDL_HOME=/home/cdsw/BigDL
export SPARK_HOME=/opt/cloudera/parcels/SPARK2/lib/spark2
export VERSION=0.2.0-SNAPSHOT
export MASTER=yarn
export PYTHON_API_ZIP_PATH=${BigDL_HOME}/dist/lib/bigdl-${VERSION}-python-api.zip
export BigDL_JAR_PATH=${BigDL_HOME}/dist/lib/bigdl-${VERSION}-jar-with-dependencies.jar
export PYTHONPATH=${PYTHON_API_ZIP_PATH}:$PYTHONPATH

${SPARK_HOME}/bin/spark-submit \
    --master ${MASTER} \
    --deploy-mode client \
    --driver-cores 2  \
    --driver-memory 2g  \
    --executor-cores 2  \
    --executor-memory 4g \
    --num-executors 4 \
    --conf spark.akka.frameSize=64 \
    --py-files ${PYTHON_API_ZIP_PATH},${BigDL_HOME}/pyspark/dl/models/textclassifier/textclassifier.py  \
    --jars ${BigDL_JAR_PATH} \
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
    --conf spark.driver.extraClassPath=${BigDL_JAR_PATH} \
    --conf spark.yarn.appMasterEnv.PYSPARK_PYTHON=/usr/conda/envs/py27/bin/python \
    --conf spark.yarn.appMasterEnv.PYSPARK_DRIVER_PYTHON=/usr/conda/envs/py27/bin/python \
    --conf spark.executor.extraClassPath=bigdl-${VERSION}-jar-with-dependencies.jar \
    ${BigDL_HOME}/pyspark/dl/models/textclassifier/textclassifier.py \
     --max_epoch 3 \
     --model gru
