FROM kaggle/python0:latest

# Continue TensorFlow build from python0
RUN cd /usr/local/src/tensorflow && \
    bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg && \
    cd /tmp/tensorflow_pkg && pip install `find . -name "*whl"`


RUN pip install seaborn python-dateutil spacy dask pytagcloud pyyaml ggplot joblib \
    husl geopy ml_metrics mne pyshp gensim
