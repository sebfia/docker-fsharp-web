FROM sebfia/fsharp
MAINTAINER Sebastian Fialka <sebastian.fialka@sebfia.net>

ENV LIBUV_PREFIX /opt/libuv
ENV LIBUV_VERSION v1.11.0
ENV LIBUV_BASENAME libuv-$LIBUV_VERSION
ENV LIBUV_ARCHIVE $LIBUV_BASENAME.tar.gz
ENV LIBUV_ARCHIVE_URL dist.libuv.org/dist/$LIBUV_VERSION/$LIBUV_ARCHIVE

RUN apt-get -y update && \
    apt-get -y --no-install-recommends install libtool make automake wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p $LIBUV_PREFIX/src && \
    cd $LIBUV_PREFIX/src && \
    wget $LIBUV_ARCHIVE_URL && \
    tar xf $LIBUV_ARCHIVE && \
    cd $LIBUV_BASENAME && \
    libtoolize -c && \
    ./autogen.sh && \
    ./configure --prefix=$LIBUV_PREFIX && \
    make && \
    make install && \
    rm -rf $LIBUV_PREFIX/src && \
    cd ~ && \
    echo $LIBUV_PREFIX/lib/ > /etc/ld.so.conf.d/libuv.conf && ldconfig

ENV CMAKE_INCLUDE_PATH $LIBUV_PREFIX/include/:$CMAKE_INCLUDE_PATH
ENV CMAKE_LIBRARY_PATH $LIBUV_PREFIX/lib/:$CMAKE_LIBRARY_PATH

CMD ["fsharpi"]
