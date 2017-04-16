#Get  the epel repo
mkdir deleteme && cd deleteme && \
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
yum install epel-release-latest-7.noarch.rpm && \
cd .. && rm -rf deleteme

#Prepare the system for Caffe

yum --enablerepo=epel  -y  install gcc gcc-c++ cmake \
gcc-gfortran.x86_64 \
bzip2-devel \
openblas-devel glog-devel gflags-devel hdf5 opencv-devel  \
lmdb-devel.x86_64 \
snappy-devel.x86_64 numpy \
hdf5-devel.x86_64 leveldb-devel.x86_64 \
protobuf-devel.x86_64 protobuf-compiler.x86_64 protobuf-c-compiler.x86_64 

#Boost
mkdir deleteme
cd deleteme
wget http://downloads.sourceforge.net/project/boost/boost/1.61.0/boost_1_61_0.tar.bz2 && \
bzip2 -d boost_1_61_0.tar.bz2 && tar -xvf boost_1_61_0.tar && \
cd boost_1_61_0 && \
bash ./bootstrap.sh && ./b2 install

#install caffe in your home directory
if [ $# -eq 0 ]
  then
    echo "Please specify the user name"
    exit
fi


if ! id -u $1 > /dev/null 2>&1; then
    echo "The user $1 does not exist; creating one"
    adduser $1
fi


#install caffe in your home directory
runuser -l $1 -c "git clone https://github.com/yahoo/CaffeOnSpark.git --recursive /home/'$1'/CaffeOnSpark"
runuser -l $1 -c "echo CAFFE_ON_SPARK=/home/'$1'/CaffeOnSpark >> /home/'$1'/.bashrc"
runuser -l $1 -c "cp /home/'$1'/CaffeOnSpark/caffe-public/Makefile.config.example /home/'$1'/CaffeOnSpark/caffe-public/Makefile.config"
runuser -l $1 -c "echo \"INCLUDE_DIRS += ${JAVA_HOME}/include\" >> /home/'$1'/CaffeOnSpark/caffe-public/Makefile.config"
