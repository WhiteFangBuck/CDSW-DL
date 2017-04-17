export SPARK_HOME=/opt/cloudera/parcels/SPARK2/lib/spark2
export PATH=$SPARK_HOME/bin:$PATH

spark-submit \
--conf spark.yarn.appMasterEnv.PYSPARK_PYTHON=/usr/anaconda2/envs/py27/bin/python \
--conf spark.yarn.appMasterEnv.PYSPARK_DRIVER_PYTHON=/usr/anaconda2/envs/py27/bin/python \
--master yarn --deploy-mode client \
--queue cpu --num-executors 2  --executor-memory 1g \
--py-files tfsparkv.zip,TensorFlowOnSpark/examples/mnist/spark/mnist_dist.py \
--conf spark.dynamicAllocation.enabled=false \
--conf spark.yarn.maxAppAttempts=1 \
--conf spark.executor.heartbeatInterval=3600s \
--conf spark.executorEnv.LD_LIBRARY_PATH="/opt/cloudera/parcels/CDH/lib64:$JAVA_HOME/jre/lib/amd64/server" \
TensorFlowOnSpark/examples/mnist/spark/mnist_spark.py \
--images hdfs://nameservice1/user/admin/mnist_1/csv/train/images \
--labels hdfs://nameservice1/user/admin/mnist_1/csv/train/labels \
--mode train \
--model hdfs://nameservice1/user/admin/model_tf
