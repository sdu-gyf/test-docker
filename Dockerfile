FROM ubuntu:16.04
COPY pip.conf /etc/pip.conf
# Ali apt-get source.list
#RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
#    echo "deb-src http://archive.ubuntu.com/ubuntu xenial main restricted" >> /etc/apt/sources.list && \
#    echo "deb http://mirrors.aliyun.com/ubuntu/ xenial main restricted" >> /etc/apt/sources.list && \
#    echo "deb-src http://mirrors.aliyun.com/ubuntu/ xenial main restricted multiverse universe" >> /etc/apt/sources.list && \
#    echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted" >> /etc/apt/sources.list && \
#    echo "deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted multiverse universe" >> /etc/apt/sources.list && \
#    echo "deb http://mirrors.aliyun.com/ubuntu/ xenial universe" >> /etc/apt/sources.list && \
#    echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-updates universe" >> /etc/apt/sources.list && \
#    echo "deb http://mirrors.aliyun.com/ubuntu/ xenial multiverse" >> /etc/apt/sources.list && \
#    echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-updates multiverse" >> /etc/apt/sources.list && \
#    echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
#    echo "deb-src http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
#    echo "deb http://archive.canonical.com/ubuntu xenial partner" >> /etc/apt/sources.list && \
#    echo "deb-src http://archive.canonical.com/ubuntu xenial partner" >> /etc/apt/sources.list && \
#    echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted" >> /etc/apt/sources.list && \
#    echo "deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted multiverse universe" >> /etc/apt/sources.list && \
#    echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-security universe" >> /etc/apt/sources.list && \
#    echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-security multiverse" >> /etc/apt/sources.list &&\
#    apt-get update --fix-missing
    
RUN apt-get update --fix-missing    

RUN apt-get install -y \
        cmake \
        libtool \
	    wget \
        git \
	      vim \
        tree 

RUN apt-get install -y gdb

RUN apt-get install -y \
        python-dev python-paramiko \
        python-pip python-cffi python-numpy python-scipy \
        libgfortran3 libopenblas-dev \
        libleveldb-dev libffi-dev libbz2-dev
RUN apt-get install -y \
        libssl-dev liblmdb-dev dialog \
        pkg-config libopencv-dev libncurses5-dev \
        libgflags-dev libhdf5-10 libhdf5-serial-dev libhdf5-dev \
        libsnappy-dev libatlas-base-dev graphviz libsqlite3-dev sqlite3
#for se5
RUN apt-get install -y \
                sudo \
                u-boot-tools

RUN git clone -b 4.1.0 --depth=1 https://github.com/opencv/opencv.git && \
    cd opencv && \
    mkdir build && \
    cd build && \
    cmake -DWITH_LIBV4L=ON .. && \
    make -j$(nproc) && \
    make install && \
    cd ../../ && rm -rf opencv && \
mkdir -p /data/release/toolchains/gcc && \
    cd /data/release/toolchains/gcc && \
    wget https://releases.linaro.org/components/toolchain/binaries/6.3-2017.05/aarch64-linux-gnu/gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu.tar.xz && \
    tar xf gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu.tar.xz && \
    rm -f gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu.tar.xz

RUN wget https://www.python.org/ftp/python/3.7.3/Python-3.7.3.tgz && \
    tar -xvf Python-3.7.3.tgz && \
    cd Python-3.7.3 && \
    ./configure --enable-shared --enable-loadable-sqlite-extensions && \
    make -j4 && \
    make install && \
    rm -rf /var/lib/apt/lists/* && \
    ln -s /usr/local/bin/pip3 /usr/bin/pip3 && \
    ln -s /usr/local/bin/python3 /usr/bin/python3

RUN ldconfig /usr/local/lib 

RUN mkdir -p /tmp/googletest && \
    cd /tmp/googletest && \
    git clone https://github.com/google/googletest && \
    cd googletest && \
    mkdir build && cd build && \
    cmake -DCMAKE_CXX_STANDARD=11 .. && make && make install && \
    cd /tmp && rm -rf /tmp/googletest

RUN pip install --upgrade pip==19.2.1 && \
    pip3 install --upgrade pip==20.3.4 &&\
ldconfig && \
    apt-get clean && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* 

RUN pip3 install \
         mxnet==1.6.0  gluoncv \
         tensorflow==1.13.1 \
         onnx==1.7.0 \
         onnxruntime==1.3.0 \
         torch==1.5.0+cpu torchvision==0.6.0+cpu -f https://download.pytorch.org/whl/torch_stable.html \
         scikit-image \
         opencv-python opencv-contrib-python \
         sphinx sphinx-autobuild sphinx_rtd_theme recommonmark \
         jupyter \
         plotly \
         graphviz \
         pandas Cython nose leveldb lmdb python-gflags && \
         rm -rf ~/.cache/pip/*

ENV PATH /data/release/toolchains/gcc/gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu/bin:$PATH

WORKDIR /workspace

