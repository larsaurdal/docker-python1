FROM kaggle/python0:latest

RUN pip install seaborn python-dateutil spacy dask pytagcloud pyyaml ggplot joblib \
    husl geopy ml_metrics mne pyshp gensim
