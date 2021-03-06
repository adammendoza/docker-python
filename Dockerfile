FROM continuumio/anaconda3:latest

RUN conda install pip statsmodels seaborn python-dateutil nltk spacy dask -y -q && \
    pip install pytagcloud pyyaml ggplot theano joblib husl geopy ml_metrics mne pyshp gensim && \
    apt-get update && apt-get install -y git && apt-get install -y build-essential && \
    apt-get install -y libfreetype6-dev && \
    apt-get install -y libglib2.0-0 libxext6 libsm6 libxrender1 libfontconfig1 --fix-missing && \
    # Latest sklearn && \
    cd /usr/local/src && git clone https://github.com/scikit-learn/scikit-learn.git && \
    cd scikit-learn && python setup.py build && python setup.py install && \
    # textblob
    pip install textblob && \
    #word cloud
    pip install git+git://github.com/amueller/word_cloud.git && \
    #igraph
    pip install python-igraph && \
    #h2o
    DEBIAN_FRONTEND=noninteractive apt-get install -y wget unzip software-properties-common python-software-properties && \
    add-apt-repository -y ppa:webupd8team/java && \
    apt-get update -q && \
    echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y oracle-java7-installer && \
    apt-get clean && \
    cd /usr/local/src && mkdir h2o && cd h2o && \
    wget http://h2o-release.s3.amazonaws.com/h2o/latest_stable -O latest && \
    wget --no-check-certificate -i latest -O h2o.zip && rm latest && \
    unzip h2o.zip && rm h2o.zip && cp h2o-*/h2o.jar . && \
    pip install `find . -name "*whl"`
    #xgboost
    cd /usr/local/src && mkdir xgboost && cd xgboost && \
    git clone https://github.com/dmlc/xgboost.git && cd xgboost && \
    make && cd python-package && python setup.py install && \
    #lasagne
    cd /usr/local/src && mkdir Lasagne && cd Lasagne && \
    git clone https://github.com/Lasagne/Lasagne.git && cd Lasagne && \
    pip install -r requirements.txt && python setup.py install && \
    #keras
    cd /usr/local/src && mkdir keras && cd keras && \
    git clone https://github.com/fchollet/keras.git && \
    cd keras && python setup.py install && \
    #neon
    cd /usr/local/src && \
    git clone https://github.com/NervanaSystems/neon.git && \
    cd neon && pip install -e . && \
    #nolearn
    cd /usr/local/src && mkdir nolearn && cd nolearn && \
    git clone https://github.com/dnouri/nolearn.git && cd nolearn && \
    echo "x" > README.rst && echo "x" > CHANGES.rst && \
    python setup.py install && \
    # put theano compiledir inside /tmp (it needs to be in writable dir)
    printf "[global]\nbase_compiledir = /tmp/.theano\n" > /.theanorc && \
    cd /usr/local/src &&  git clone https://github.com/pybrain/pybrain && \
    cd pybrain && python setup.py install && \
    # Base ATLAS plus tSNE
    apt-get install -y libatlas-base-dev && \
    # NOTE: we provide the tsne package, but sklearn.manifold.TSNE now does the same
    # job
    cd /usr/local/src && git clone https://github.com/danielfrg/tsne.git && \
    cd tsne && python setup.py install && \
    cd /usr/local/src && git clone https://github.com/ztane/python-Levenshtein && \
    cd python-Levenshtein && python setup.py install && \
    cd /usr/local/src && git clone https://github.com/arogozhnikov/hep_ml.git && \
    cd hep_ml && pip install .  && \
    # chainer
    pip install chainer && \
    # NLTK Project datasets
    mkdir -p /usr/share/nltk_data && \
    python -m nltk.downloader -d /usr/share/nltk_data all && \
    # Stop-words
    pip install stop-words && \
    # Geohash
    pip install Geohash && \
    # DEAP genetic algorithms framework
    pip install deap && \
    # TPOT pipeline infrastructure
    pip install tpot && \
    # haversine
    pip install haversine

    # Install OpenCV-3 with Python support
    # We build libpng 1.6.17 from source because the apt-get version is too out of
    # date for OpenCV-3.
RUN apt-get update && apt-get -y install cmake imagemagick && \
    apt-get -y install libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev && \
    apt-get -y install libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev && \
    cd /usr/local/src && wget http://downloads.sourceforge.net/libpng/libpng-1.6.17.tar.xz && \
    tar -xf libpng-1.6.17.tar.xz && cd libpng-1.6.17 && \
    ./configure --prefix=/usr --disable-static && make && make install && \
    cd /usr/local/src && git clone https://github.com/Itseez/opencv.git && \
    cd /usr/local/src/opencv && \
    mkdir build && cd build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -D WITH_FFMPEG=OFF -D BUILD_NEW_PYTHON_SUPPORT=ON -D WITH_V4L=ON -D WITH_QT=OFF -D WITH_OPENGL=ON -D PYTHON3_LIBRARY=/opt/conda/lib/libpython3.5m.so -D PYTHON3_INCLUDE_DIR=/opt/conda/include/python3.5m/ .. && \
    make -j $(nproc) && make install && \
    echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf && ldconfig && \
    cp /usr/local/lib/python3.5/site-packages/cv2.cpython-35m-x86_64-linux-gnu.so /opt/conda/lib/python3.5/site-packages/ 

RUN apt-get -y install libgeos-dev && \
    cd /usr/local/src && git clone https://github.com/matplotlib/basemap.git && \
    export GEOS_DIR=/usr/local && \
    cd basemap && python setup.py install && \
    # Pillow (PIL)
    apt-get -y install zlib1g-dev liblcms2-dev libwebp-dev && \
    pip install Pillow && \
    cd /usr/local/src && git clone https://github.com/vitruvianscience/opendeep.git && \
    cd opendeep && python setup.py develop  && \
    # Cartopy and dependencies
    yes | conda install proj4 && \
    pip install packaging && \
    cd /usr/local/src && git clone https://github.com/Toblerity/Shapely.git && \
    cd Shapely && python setup.py install && \
    cd /usr/local/src && git clone https://github.com/SciTools/cartopy.git && \
    cd cartopy && python setup.py install && \
    pip install ibis-framework
    
    # set backend for matplotlib to Agg
RUN matplotlibrc_path=$(python -c "import site, os, fileinput; packages_dir = site.getsitepackages()[0]; print(os.path.join(packages_dir, 'matplotlib', 'mpl-data', 'matplotlibrc'))") && \
    sed -i 's/^backend      : Qt4Agg/backend      : Agg/' $matplotlibrc_path

    # MXNet
    # The g++4.8 dependency is not currently available via the default apt-get
    # channels, so we add the Ubuntu repository (which requires python-software-properties
    # so we can call `add-apt-repository`. There's also some mucking about with GPG keys
    # required.
RUN apt-get install -y python-software-properties && \
    add-apt-repository "deb http://archive.ubuntu.com/ubuntu trusty main" && \
    apt-get install debian-archive-keyring && apt-key update && apt-get update && \
    apt-get install --force-yes -y ubuntu-keyring && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 40976EAF437D05B5 3B4FE6ACC0B21F32 && \
    mv /var/lib/apt/lists /tmp && mkdir -p /var/lib/apt/lists/partial && \
    apt-get clean && apt-get update && apt-get install -y g++-4.8 && \
    cd /usr/local/src && git clone --recursive https://github.com/dmlc/mxnet && \
    cd /usr/local/src/mxnet && cp make/config.mk . && sed -i 's/CC = gcc/CC = gcc-4.8/' config.mk && \
    sed -i 's/CXX = g++/CXX = g++-4.8/' config.mk && \
    sed -i 's/ADD_LDFLAGS =/ADD_LDFLAGS = -lstdc++/' config.mk && \
    make && cd python && python setup.py install

    # Stop ipython nbconvert trying to rewrite its folder hierarchy
RUN mkdir -p /root/.jupyter && touch /root/.jupyter/jupyter_nbconvert_config.py && touch /root/.jupyter/migrated && \
    mkdir -p /.jupyter && touch /.jupyter/jupyter_nbconvert_config.py && touch /.jupyter/migrated


