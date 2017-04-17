export SPARK_HOME=/opt/cloudera/parcels/SPARK2/lib/spark2
export PATH=$SPARK_HOME/bin:$PATH

spark-submit \
--master yarn --deploy-mode client \
--num-executors 3 \
--files ./lenet_memory_solver.prototxt,./lenet_memory_train_test.prototxt \
--conf spark.driver.extraLibraryPath="${LD_LIBRARY_PATH}" \
--conf spark.executorEnv.LD_LIBRARY_PATH="${LD_LIBRARY_PATH}" \
--class com.yahoo.ml.caffe.CaffeOnSpark \
./caffe-grid-0.1-SNAPSHOT-jar-with-dependencies.jar \
-train -features accuracy,loss \
-label label \
-conf lenet_memory_solver.prototxt \
-connection ethernet \
-model mnist.model \
-output mnist_features_result
