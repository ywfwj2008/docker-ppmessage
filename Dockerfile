FROM ywfwj2008/tengine:latest
MAINTAINER ywfwj2008 <ywfwj2008@163.com>

ENV MYSQL_CONNECTOR_PYTHON_VERSION=2.0.4
ENV FFMPEG_VERSION=2.8.7

RUN apt-get update && apt-get upgrade && \
    apt-get install -y python-dev python-pip git-core

RUN pip install axmlparserpy \
    beautifulsoup4 \
    biplist \
    evernote \
    filemagic \
    geoip2 \
    green \
    git+https://github.com/senko/python-video-converter.git \
    hg+https://dingguijin@bitbucket.org/dingguijin/apns-client \
    identicon \
    ipython \
    jieba \
    paramiko \
    paho-mqtt \
    pillow \
    ppmessage-mqtt \
    pyipa \
    pypinyin \
    pyparsing \
    python-dateutil \
    python-gcm \
    python-magic \
    qiniu \
    qrcode \
    readline \
    redis \
    rq \
    supervisor \
    sqlalchemy \
    tornado \
    xlrd \
    numpy \
    matplotlib \
    scipy \
    scikit-learn

# 安装 mysql-connector-python
RUN wget http://cdn.mysql.com/Downloads/Connector-Python/mysql-connector-python-$MYSQL_CONNECTOR_PYTHON_VERSION.tar.gz && \
    tar -xzvf mysql-connector-python-$MYSQL_CONNECTOR_PYTHON_VERSION.tar.gz && \
    cd mysql-connector-python-$MYSQL_CONNECTOR_PYTHON_VERSION && \
    python setup.py install

# 安装 ffmpeg
RUN wget http://ffmpeg.org/releases/ffmpeg-FFMPEG_VERSION.tar.bz2 && \
    tar -xjvf ffmpeg-FFMPEG_VERSION.tar.bz2 && \
    cd ffmpeg-FFMPEG_VERSION && \
    ./configure --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-version3 --enable-nonfree --disable-yasm --enable-libmp3lame --enable-libopus --enable-libfdk-aac
    make && make install

# 安装 libmaxminddb
RUN git clone --recursive https://github.com/maxmind/libmaxminddb && \
    cd libmaxminddb && \
    ./bootstrap && \
    ./configure && \
    make && make install