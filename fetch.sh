#!/bin/sh

GTEST_VERSION=1.8.0
GTEST_GZ=target/googletest-$GTEST_VERSION.tar.gz

SNAPPY_VERSION=1.1.4
SNAPPY_GZ=target/snappy-$SNAPPY_VERSION.tar.gz

LEVELDB_VERSION=1.19
LEVELDB_GZ=target/leveldb-$LEVELDB_VERSION.tar.gz

LIBUV_VERSION=1.11.0
LIBUV_GZ=target/libuv-$LIBUV_VERSION.tar.gz

UWS_BRANCH=cors3
UWS_GZ=target/uws-$UWS_BRANCH.tar.gz

JSON_VERSION=2.1.1
JSON_H=nlohmann-json/json.hpp

LIBPNG_VERSION=1.6.29
LIBPNG_GZ=target/libpng-$LIBPNG_VERSION.tar.gz

fetch_gtest() {
[ ! -e googletest/googletest ] && \
    wget https://github.com/google/googletest/archive/release-$GTEST_VERSION.tar.gz -O $GTEST_GZ  && \
    tar -xvzf $GTEST_GZ --strip-components=1 -C googletest
}

fetch_snappy() {
# https://github.com/google/snappy/releases/download/$SNAPPY_VERSION/snappy-$SNAPPY_VERSION.tar.gz has a different source!
[ ! -e snappy/snappy.h ] && \
    wget https://github.com/google/snappy/archive/$SNAPPY_VERSION.tar.gz -O $SNAPPY_GZ && \
    tar -xvzf $SNAPPY_GZ --strip-components=1 -C snappy
}

fetch_leveldb() {
[ ! -e leveldb/include ] && \
    wget https://github.com/google/leveldb/archive/v$LEVELDB_VERSION.tar.gz -O $LEVELDB_GZ && \
    tar -xvzf $LEVELDB_GZ --strip-components=1 -C leveldb && \
    patch leveldb/port/port.h < leveldb/gn-diff/leveldb_port.diff && \
    patch leveldb/include/leveldb/slice.h < leveldb/gn-diff/leveldb_slice.diff
}

fetch_libuv() {
[ ! -e libuv/include ] && \
    wget https://github.com/libuv/libuv/archive/v$LIBUV_VERSION.tar.gz -O $LIBUV_GZ && \
    tar -xvzf $LIBUV_GZ --strip-components=1 -C libuv
}

fetch_uws() {
[ ! -e uWebSockets/src ] && \
    wget http://github.com/dyu/uWebSockets/archive/$UWS_BRANCH.tar.gz -O $UWS_GZ && \
    tar -xvzf $UWS_GZ --strip-components=1 -C uWebSockets
}

fetch_json() {
[ ! -e $JSON_H ] && \
    wget https://github.com/nlohmann/json/releases/download/v$JSON_VERSION/json.hpp -O $JSON_H
}

fetch_libpng() {
[ ! -e libpng/png.h ] && \
    wget https://github.com/glennrp/libpng/archive/v$LIBPNG_VERSION.tar.gz -O $LIBPNG_GZ && \
    tar -xvzf $LIBPNG_GZ --strip-components=1 -C libpng
}

fetch_all() {
    fetch_gtest
    fetch_snappy
    fetch_leveldb
    fetch_libuv
    fetch_uws
    fetch_json
    fetch_libpng
}

fetch_arg() {
case "$1" in
    gtest)
    fetch_gtest
    ;;
    
    snappy)
    fetch_snappy
    ;;
    
    leveldb)
    fetch_leveldb
    ;;
    
    libuv)
    fetch_libuv
    ;;
    
    uws)
    fetch_uws
    ;;
    
    json)
    fetch_json
    ;;
    
    libpng)
    fetch_libpng
    ;;
    
esac
}

CURRENT_DIR=$PWD
# locate
if [ ! -n "$BASH_SOURCE" ]; then
    SCRIPT_DIR=`dirname "$(readlink -f "$0")"`
else
    F=$BASH_SOURCE
    while [ -h "$F" ]; do
        F="$(readlink "$F")"
    done
    SCRIPT_DIR=`dirname "$F"`
fi

cd $SCRIPT_DIR

mkdir -p target

if [ -n "$1" ]; then
    for i in $@; do
    fetch_arg $i
    done
else
    fetch_all
fi

