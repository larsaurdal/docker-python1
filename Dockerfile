FROM kaggle/python0:latest

# Continue TensorFlow build from python0
RUN mkdir -p /usr/local/src/tfbuild && cd /usr/local/src/tensorflow && \
    # For the *_strategy options see https://github.com/bazelbuild/bazel/issues/698#issuecomment-164041244
    TEST_TMPDIR=/usr/local/src/tfbuild bazel build --verbose_failures --genrule_strategy=standalone --spawn_strategy=standalone -c opt //tensorflow/tools/pip_package:build_pip_package && \
    bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg && \
    cd /tmp/tensorflow_pkg && pip install `find . -name "*whl"`


RUN pip install seaborn python-dateutil spacy dask pytagcloud pyyaml ggplot joblib \
    husl geopy ml_metrics mne pyshp gensim
