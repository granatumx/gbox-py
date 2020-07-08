FROM python:3.8
# python:3.8
# :3.6.8
# FROM python:3.6.4
# FROM python:2.7.17

MAINTAINER "Xun Zhu" zhuxun2@gmail.com

# Make terminal colorful, useful for build information, editing, etc...
ENV TERM=xterm-256color
ENV PATH="$PATH:."

ENV DEBIAN_FRONTEND noninteractive
ENV TZ America/New_York

WORKDIR /usr/src/app

RUN apt-get update

RUN apt-get install -y apt-utils
RUN apt-get install -y build-essential git vim
RUN apt-get install -y curl

# RUN ln -sf /usr/bin/python /usr/local/bin/python

ENV DEBIAN_FRONTEND noninteractive
ENV TZ America/New_York

RUN apt-get install -y tzdata
# RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime

RUN apt-get -y install python-pandas
RUN apt-get -y install python-numpy
RUN apt-get -y install python-scipy
RUN apt-get -y install python3-sklearn python3-sklearn-lib

RUN apt-get -y install python-pip
RUN pip install cmake
# ==3.11.0

RUN pip install pathlib


# COPY ./requirements.txt .
# RUN pip install --no-cache-dir -r ./requirements.txt
RUN pip install Cython
RUN pip install ansicolors Keras Theano anndata bokeh xlrd colour
RUN pip install h5py hdbscan
RUN pip install ipython
RUN pip install joblib
RUN pip install natsort
RUN pip install matplotlib
RUN pip install networkx 
RUN pip install numba

# Install mailjet To implement automated email for bugs #
RUN pip install mailjet_rest

RUN apt-get install -y libtool
# RUN apt-get install -y llvm-7
# RUN which llvm-config

# RUN pip install numba 
RUN pip install seaborn 
RUN pip install statsmodels tables 


#RUN apt-get install -y python-igraph
RUN apt-get install -y libxml2 libxml2-dev libz-dev
RUN apt-get install -y m4
RUN apt-get install -y autotools-dev
RUN apt-get install -y automake
RUN apt-get install -y bison flex
RUN pip install python-igraph
#RUN pip install python-igraph 
RUN pip install ipdb
RUN pip install tqdm
RUN pip install louvain

COPY ./granatum_clustering/ ./granatum_clustering
RUN cd ./granatum_clustering && pip install -e .

COPY ./granatum_deeplearning/ ./granatum_deeplearning
RUN cd ./granatum_deeplearning && pip install -e .

RUN pip install git+https://github.com/DmitryUlyanov/Multicore-TSNE.git@682531fe21db7e10c1f7b0a783b7be86128273bc

# COPY ./granatum_sdk/ ./granatum_sdk
# RUN cd ./granatum_sdk && pip install -e .

COPY ./zgsea ./zgsea
RUN cd ./zgsea && pip install -e .

COPY ./jammit/ ./jammit
RUN cd ./jammit && pip install -e .

# RUN pip install git+https://gitlab.com/xz/granatum_sdk.git@a66485f

# RUN apt-get -y install python3-pip
RUN pip install git+https://github.com/chriscainx/mnnpy.git

#@750bba42ef7e26ac1eafe75e772440b12160814c

# COPY ./scanpy/ ./scanpy
# RUN cd ./scanpy && pip install -e .
RUN pip install scanpy
RUN pip install tensorflow

RUN pip install modin[ray]

COPY ./keras.json /root/.keras/keras.json
COPY ./matplotlibrc /root/.config/matplotlib/matplotlibrc
COPY . .

# Set version correctly so user can install gbox
# Requires bash and sed to set version in yamls
# Can modify if base OS does not support bash/sed
RUN apt-get update
RUN apt-get install -y sed bash
ARG VER=1.0.0
ARG GBOX=granatumx/gbox-py:1.0.0
ENV VER=$VER
ENV GBOX=$GBOX
WORKDIR /usr/src/app
RUN ./GBOXtranslateVERinYAMLS.sh
RUN ./GBOXgenTGZ.sh

CMD [ "python", "./greet.py" ]
