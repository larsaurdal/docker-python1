FROM kaggle/python0:latest

RUN pip install pytagcloud pyyaml ggplot joblib husl geopy ml_metrics mne pyshp gensim && \
    apt-get install -y libfreetype6-dev && \
    apt-get install -y libglib2.0-0 libxext6 libsm6 libxrender1 libfontconfig1 --fix-missing && \
    # textblob
    pip install textblob && \
    #word cloud
    pip install git+git://github.com/amueller/word_cloud.git && \
    #igraph
    pip install python-igraph && \
    #xgboost
    cd /usr/local/src && mkdir xgboost && cd xgboost && \
    git clone --recursive https://github.com/dmlc/xgboost.git && cd xgboost && \
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
    # Dev branch of Theano
    pip install git+git://github.com/Theano/Theano.git --upgrade --no-deps && \
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
    # NLTK Downloader no longer continues smoothly after an error, so we explicitly list
    # the corpuses that work
    python -m nltk.downloader -d /usr/share/nltk_data abc alpino \
    averaged_perceptron_tagger basque_grammars biocreative_ppi bllip_wsj_no_aux \
book_grammars brown brown_tei cess_cat cess_esp chat80 city_database cmudict \
comparative_sentences comtrans conll2000 conll2002 conll2007 crubadan dependency_treebank \
europarl_raw floresta framenet_v15 gazetteers genesis gutenberg hmm_treebank_pos_tagger \
ieer inaugural indian jeita kimmo knbc large_grammars lin_thesaurus mac_morpho machado \
masc_tagged maxent_ne_chunker maxent_treebank_pos_tagger moses_sample movie_reviews \
mte_teip5 names nps_chat omw opinion_lexicon panlex_swadesh paradigms \
pil pl196x ppattach problem_reports product_reviews_1 product_reviews_2 propbank \
pros_cons ptb punkt qc reuters rslp rte sample_grammars semcor senseval sentence_polarity \
sentiwordnet shakespeare sinica_treebank smultron snowball_data spanish_grammars \
state_union stopwords subjectivity swadesh switchboard tagsets timit toolbox treebank \
twitter_samples udhr2 udhr unicode_samples universal_tagset universal_treebanks_v20 \
verbnet webtext word2vec_sample wordnet wordnet_ic words ycoe && \
    # Stop-words
    pip install stop-words

    # Prepare for OpenCV 3
RUN apt-get update && \
    # The apt-get version of imagemagick has gone mad, and wants to remove sysvinit.
    apt-get -y build-dep imagemagick && \
    wget http://www.imagemagick.org/download/ImageMagick-6.9.3-7.tar.gz && \
    tar xzf ImageMagick-6.9.3-7.tar.gz && cd ImageMagick-6.9.3-7 && ./configure && \
    make && make install && \
    apt-get -y install libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev && \
    apt-get -y install libtbb2 libtbb-dev libjpeg-dev libtiff-dev libjasper-dev && \
    # apt-get gives you cmake 2.8, which fails to find Py3.4's libraries and headers. The current
    # version is cmake 3.2, which does.
    cd /usr/local/src && git clone https://github.com/Kitware/CMake.git && \
    # --system-curl needed for OpenCV's IPP download, see https://stackoverflow.com/questions/29816529/unsupported-protocol-while-downlod-tar-gz-package/32370027#32370027
    cd CMake && ./bootstrap --system-curl && make && make install && \
    cd /usr/local/src && git clone https://github.com/Itseez/opencv.git

    # Install OpenCV-3 with Python support
RUN cd /usr/local/src/opencv && \
    mkdir build && cd build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -D WITH_FFMPEG=OFF -D WITH_V4L=ON -D WITH_QT=OFF -D WITH_OPENGL=ON -D PYTHON3_LIBRARY=/opt/conda/lib/libpython3.4m.so -D PYTHON3_INCLUDE_DIR=/opt/conda/include/python3.4m/ -D PYTHON_LIBRARY=/opt/conda/lib/libpython3.4m.so -D PYTHON_INCLUDE_DIR=/opt/conda/include/python3.4m/ .. && \
    make -j $(nproc) && make install && \
    echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf && ldconfig && \
    cp /usr/local/lib/python3.4/site-packages/cv2.cpython-34m.so /opt/conda/lib/python3.4/site-packages/ 

RUN apt-get -y install libgeos-dev && \
    # pyshp and pyproj are now external dependencies of Basemap
    pip install pyshp pyproj && \
    cd /usr/local/src && git clone https://github.com/matplotlib/basemap.git && \
    export GEOS_DIR=/usr/local && \
    cd basemap && python setup.py install && \
    # Pillow (PIL)
    apt-get -y install zlib1g-dev liblcms2-dev libwebp-dev && \
    pip install Pillow && \
    cd /usr/local/src && git clone https://github.com/vitruvianscience/opendeep.git && \
    cd opendeep && python setup.py develop  && \
    # sasl is apparently an ibis dependency
    apt-get -y install libsasl2-dev && \
    pip install ibis-framework && \
    # Cartopy plus dependencies
    yes | conda install proj4 && \
    pip install packaging && \
    cd /usr/local/src && git clone https://github.com/Toblerity/Shapely.git && \
    cd Shapely && python setup.py install && \
    cd /usr/local/src && git clone https://github.com/SciTools/cartopy.git && \
    cd cartopy && python setup.py install
