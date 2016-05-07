FROM ywfwj2008/tengine:latest
MAINTAINER ywfwj2008 <ywfwj2008@163.com>

ENV MYSQL_CONNECTOR_PYTHON_VERSION=2.1.3
ENV FFMPEG_VERSION=3.0.2

WORKDIR /tmp

# for debian install 'libjpeg62-turbo-dev', for ubuntu install 'libjpeg8-dev'
RUN apt-get update && apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        apt-file \
        apt-utils \
        autoconf \
        automake \
        git-core \
        libblas-dev \
        liblapack-dev \
        libatlas-base-dev \
        gfortran \
        libffi-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmagic1 \
        libmp3lame-dev \
        libncurses5-dev \
        libopencore-amrwb-dev \
        libopencore-amrnb-dev \
        libopus-dev \
        libpng12-dev \
        libpcre3-dev \
        libssl-dev \
        libtool \
        mercurial \
        pkg-config \
        python \
        python-dev \
        python-pip

# some python modules need libmaxminddb, install it before run 'pip install ...'
RUN git clone --recursive https://github.com/maxmind/libmaxminddb && \
    cd libmaxminddb && \
    ./bootstrap && \
    ./configure && \
    make && make install && \
    rm -rf /tmp/*

# install Python Package
RUN pip install \
        axmlparserpy \
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
        scikit-learn && \
        rm -rf /tmp/*

# install nodejs
RUN curl -sL https://deb.nodesource.com/setup_4.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g bower && \
    npm install -g gulp && \
    rm -rf /tmp/*

# install mysql-connector-python
RUN wget http://cdn.mysql.com/Downloads/Connector-Python/mysql-connector-python-$MYSQL_CONNECTOR_PYTHON_VERSION.tar.gz && \
    tar -xzvf mysql-connector-python-$MYSQL_CONNECTOR_PYTHON_VERSION.tar.gz && \
    cd mysql-connector-python-$MYSQL_CONNECTOR_PYTHON_VERSION && \
    python setup.py install && \
    rm -rf /tmp/*

# install libfdk-aac
RUN git clone git://github.com/mstorsjo/fdk-aac && \
    cd fdk-aac && \
    autoreconf -i && \
    ./configure && \
    make && make install && \
    rm -rf /tmp/*

# install ffmpeg
RUN wget -c http://ffmpeg.org/releases/ffmpeg-$FFMPEG_VERSION.tar.bz2 && \
    tar -xjvf ffmpeg-$FFMPEG_VERSION.tar.bz2 && \
    cd ffmpeg-$FFMPEG_VERSION && \
    ./configure --enable-libopencore-amrnb \
                --enable-libopencore-amrwb \
                --enable-version3 \
                --enable-nonfree \
                --disable-yasm \
                --enable-libmp3lame \
                --enable-libopus \
                --enable-libfdk-aac && \
    make && make install && \
    rm -rf /tmp/*

# Other
EXPOSE 8080 80

VOLUME ["/ppmessage"]

COPY ["entrypoint.sh", "/entrypoint.sh"]

ENTRYPOINT ["/entrypoint.sh"]
