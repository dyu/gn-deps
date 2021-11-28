#!/bin/sh

GTEST_VERSION=1.8.0
GTEST_GZ=target/googletest-$GTEST_VERSION.tar.gz

SNAPPY_VERSION=1.1.4
SNAPPY_GZ=target/snappy-$SNAPPY_VERSION.tar.gz

# legacy version
#LEVELDB_LEGACY_VERSION=1.19
#LEVELDB_LEGACY_GZ=target/leveldb-$LEVELDB_LEGACY_VERSION.tar.gz

LIBUV_VERSION=1.41.0
LIBUV_GZ=target/libuv-$LIBUV_VERSION.tar.gz

UWS_BRANCH=cors3
UWS_GZ=target/uws-$UWS_BRANCH.tar.gz

JSON_VERSION=2.1.1
JSON_H=nlohmann-json/json.hpp

LIBPNG_VERSION=1.6.29
LIBPNG_GZ=target/libpng-$LIBPNG_VERSION.tar.gz

ZLIB_VERSION=1.2.11
ZLIB_GZ=target/zlib-$ZLIB_VERSION.tar.gz

fetch_gtest() {
[ ! -e googletest/googletest ] && \
    curl https://github.com/google/googletest/archive/release-$GTEST_VERSION.tar.gz -Lso $GTEST_GZ  && \
    tar -xvzf $GTEST_GZ --strip-components=1 -C googletest
}

fetch_snappy() {
# https://github.com/google/snappy/releases/download/$SNAPPY_VERSION/snappy-$SNAPPY_VERSION.tar.gz has a different source!
[ ! -e snappy/snappy.h ] && \
    curl https://github.com/google/snappy/archive/$SNAPPY_VERSION.tar.gz -Lso $SNAPPY_GZ && \
    tar -xvzf $SNAPPY_GZ --strip-components=1 -C snappy
}

#fetch_leveldb_legacy() {
#[ ! -e leveldb-legacy/include ] && \
#    curl https://github.com/google/leveldb/archive/v$LEVELDB_LEGACY_VERSION.tar.gz -Lso $LEVELDB_LEGACY_GZ && \
#    tar -xvzf $LEVELDB_LEGACY_GZ --strip-components=1 -C leveldb-legacy && \
#    patch leveldb-legacy/port/port.h < leveldb-legacy/gn-diff/leveldb_port.diff && \
#    patch leveldb-legacy/include/leveldb/slice.h < leveldb-legacy/gn-diff/leveldb_slice.diff
#}

fetch_leveldb() {
[ ! -e leveldb ] && git clone --depth 1 --single-branch -b gn https://github.com/dyu/leveldb.git
}

fetch_libuv() {
[ ! -e libuv/include ] && \
    curl https://github.com/libuv/libuv/archive/v$LIBUV_VERSION.tar.gz -Lso $LIBUV_GZ && \
    tar -xvzf $LIBUV_GZ --strip-components=1 -C libuv
}

fetch_uws() {
[ ! -e uWebSockets/src ] && \
    curl https://github.com/dyu/uWebSockets/archive/$UWS_BRANCH.tar.gz -Lso $UWS_GZ && \
    tar -xvzf $UWS_GZ --strip-components=1 -C uWebSockets
}

fetch_json() {
[ ! -e $JSON_H ] && \
    curl https://github.com/nlohmann/json/releases/download/v$JSON_VERSION/json.hpp -Lso $JSON_H
}

fetch_libpng() {
[ ! -e libpng/png.h ] && \
    curl https://github.com/glennrp/libpng/archive/v$LIBPNG_VERSION.tar.gz -Lso $LIBPNG_GZ && \
    tar -xvzf $LIBPNG_GZ --strip-components=1 -C libpng
}

fetch_zlib() {
[ ! -e zlib/zlib.h ] && \
    curl https://zlib.net/zlib-$ZLIB_VERSION.tar.gz -Lso $ZLIB_GZ && \
    tar -xvzf $ZLIB_GZ --strip-components=1 -C zlib
}

fetch_all() {
    fetch_gtest
    fetch_snappy
    fetch_leveldb
    fetch_libuv
    fetch_uws
    fetch_json
    fetch_libpng
    fetch_zlib
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
    
    zlib)
    fetch_zlib
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

