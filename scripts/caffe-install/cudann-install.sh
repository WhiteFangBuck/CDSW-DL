#!/bin/sh -e

### runtime

NVIDIA_GPGKEY_SUM=bd841d59a27a406e513db7d405550894188a4c1cd96bf8aa4f82f1b39e0b5c1c

curl -fsSL http://developer.download.nvidia.com/compute/cuda/repos/GPGKEY \
 | sed '/^Version/d' > /etc/pki/rpm-gpg/RPM-GPG-KEY-NVIDIA
echo "$NVIDIA_GPGKEY_SUM /etc/pki/rpm-gpg/RPM-GPG-KEY-NVIDIA" | sha256sum -c --strict -

cp cuda.repo /etc/yum.repos.d/cuda.repo

CUDA_VERSION=7.5
CUDA_PKG_VERSION=7-5-7.5-18

yum install -y \
    cuda-nvrtc-$CUDA_PKG_VERSION \
    cuda-cusolver-$CUDA_PKG_VERSION \
    cuda-cublas-$CUDA_PKG_VERSION \
    cuda-cufft-$CUDA_PKG_VERSION \
    cuda-curand-$CUDA_PKG_VERSION \
    cuda-cusparse-$CUDA_PKG_VERSION \
    cuda-npp-$CUDA_PKG_VERSION \
    cuda-cudart-$CUDA_PKG_VERSION
ln -s cuda-$CUDA_VERSION /usr/local/cuda

echo "/usr/local/cuda/lib" >> /etc/ld.so.conf.d/cuda.conf
echo "/usr/local/cuda/lib64" >> /etc/ld.so.conf.d/cuda.conf
ldconfig

cp cuda.env /etc/profile.d/cuda.sh
. /etc/profile.d/cuda.sh

### devel

yum install -y \
    cuda-core-$CUDA_PKG_VERSION \
    cuda-misc-headers-$CUDA_PKG_VERSION \
    cuda-command-line-tools-$CUDA_PKG_VERSION \
    cuda-license-$CUDA_PKG_VERSION \
    cuda-cublas-dev-$CUDA_PKG_VERSION \
    cuda-cufft-dev-$CUDA_PKG_VERSION \
    cuda-curand-dev-$CUDA_PKG_VERSION \
    cuda-cusparse-dev-$CUDA_PKG_VERSION \
    cuda-npp-dev-$CUDA_PKG_VERSION \
    cuda-cudart-dev-$CUDA_PKG_VERSION \
    cuda-driver-dev-$CUDA_PKG_VERSION

### cuDNN

CUDNN_VERSION=2
CUDNN_DOWNLOAD_SUM=4b02cb6bf9dfa57f63bfff33e532f53e2c5a12f9f1a1b46e980e626a55f380aa

curl -fsSL http://developer.download.nvidia.com/compute/redist/cudnn/v2/cudnn-6.5-linux-x64-v2.tgz -O
echo "$CUDNN_DOWNLOAD_SUM cudnn-6.5-linux-x64-v2.tgz" | sha256sum -c --strict -
tar -xzf cudnn-6.5-linux-x64-v2.tgz
cp -a cudnn-6.5-linux-x64-v2/cudnn.h /usr/local/cuda/include/
cp -a cudnn-6.5-linux-x64-v2/libcudnn* /usr/local/cuda/lib64/
rm -rf cudnn-6.5-linux-x64-v2*
ldconfig
