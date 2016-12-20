#start from a cuda capable nvidia docker image
FROM nvidia/cuda:8.0-cudnn5-devel

#copy and install an anaconda
COPY anaconda.sh /
RUN bash /anaconda.sh -b -p /root/anaconda
env PATH /root/anaconda/bin:$PATH

######################
#install caffe
RUN apt-get update
#stuff
RUN apt-get install -y g++ cmake libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libhdf5-serial-dev protobuf-compiler
#boost
RUN apt-get install -y --no-install-recommends libboost-all-dev
#atlas
RUN apt-get install -y libatlas-base-dev
#more stuff
RUN apt-get install -y libgflags-dev libgoogle-glog-dev liblmdb-dev

#python stuff
RUN pip install pydot==1.1.0 lmdb

# remove conflicting conda libtiff version
RUN conda remove -y libtiff

# it is not in anaconda???
RUN apt-get install -y git

#complie caffe
RUN git clone https://github.com/BVLC/caffe.git; cd caffe;\
	mkdir build && cd build && \
	cmake  -DCUDA_ARCH_NAME=Manual -DCUDA_ARCH_BIN="61" -DCUDA_ARCH_PTX="61" -DUSE_CUDNN=1  .. && \
	make -j 4 

#only after compiling, some versions are not aligned
RUN conda install -y protobuf

#set stuff fo pycaffe, and caffe path
ENV PYCAFFE_ROOT /caffe/python
ENV PYTHONPATH $PYCAFFE_ROOT:$PYTHONPATH
ENV PATH /caffe/build/tools:$PYCAFFE_ROOT:$PATH
RUN echo "/caffe/build/lib" >> /etc/ld.so.conf.d/caffe.conf && ldconfig

#newer libstdc++ in /usr/lib thank conda, link it
#RUN mv -vf /opt/conda/lib/libstdc++.so.6 /opt/conda/lib/libstdc++.so.6.old
#RUN ln -s /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /opt/conda/lib/libstdc++.so.6


######################
# keras
RUN pip install pydicom keras
RUN conda install -y opencv
#set theano backend for keras
ENV KERAS_BACKEND theano


######################
#xgboost
#download and build  xgb
RUN apt-get install -y build-essential 
RUN git clone --recursive https://github.com/dmlc/xgboost && \ 
        cd xgboost && make -j4 && \
        cd python-package && python setup.py install
#install xgb python
ENV PYTHONPATH /xgboost/python-package:$PYTHONPATH



######################
#stuff
WORKDIR /root/
RUN apt-get install -y wget
RUN conda install -y seaborn

######################
#start notebook
#EXPOSE 8888
CMD jupyter notebook --no-browser
