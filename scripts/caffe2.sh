wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-10.noarch.rpm && \
yum install -y epel-release-7-10.noarch.rpm

sudo yum install -y \
automake \
cmake3 \
gcc \
gcc-c++ \
git \
kernel-devel \
leveldb-devel \
lmdb-devel \
libtool \
protobuf-devel \
python-devel \
python-pip \
snappy-devel

yum install -y gflags-devel glog-devel
