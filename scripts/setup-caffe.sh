#Prepare the system for Caffe

yum -y  install gcc gcc-c++ ccmake \
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
./bootstrap && ./b2 install

#install caffe in your home directory
su - <user>
git clone https://github.com/yahoo/CaffeOnSpark.git --recursive
echo CAFFE_ON_SPARK=/home/<user>/CaffeOnSpark >> ~/.bashrc
pushd ${CAFFE_ON_SPARK}/caffe-public/
cp Makefile.config.example Makefile.config
echo "INCLUDE_DIRS += ${JAVA_HOME}/include" >> Makefile.config
vi Makefile.config
make clean && make build
