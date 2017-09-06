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

mkdir target

[ ! -e googletest/googletest ] && \
    wget https://github.com/google/googletest/archive/release-$GTEST_VERSION.tar.gz -O $GTEST_GZ  && \
    tar -xvzf $GTEST_GZ --strip-components=1 -C googletest

# https://github.com/google/snappy/releases/download/$SNAPPY_VERSION/snappy-$SNAPPY_VERSION.tar.gz has a different source!
[ ! -e snappy/snappy.h ] && \
    wget https://github.com/google/snappy/archive/$SNAPPY_VERSION.tar.gz -O $SNAPPY_GZ && \
    tar -xvzf $SNAPPY_GZ --strip-components=1 -C snappy

[ ! -e leveldb/include ] && \
    wget https://github.com/google/leveldb/archive/v$LEVELDB_VERSION.tar.gz -O $LEVELDB_GZ && \
    tar -xvzf $LEVELDB_GZ --strip-components=1 -C leveldb && \
    patch leveldb/port/port.h < leveldb/gn-diff/leveldb_port.diff && \
    patch leveldb/include/leveldb/slice.h < leveldb/gn-diff/leveldb_slice.diff

[ ! -e libuv/include ] && \
    wget https://github.com/libuv/libuv/archive/v$LIBUV_VERSION.tar.gz -O $LIBUV_GZ && \
    tar -xvzf $LIBUV_GZ --strip-components=1 -C libuv

[ ! -e uWebSockets/src ] && \
    wget http://github.com/dyu/uWebSockets/archive/$UWS_BRANCH.tar.gz -o $UWS_GZ && \
    tar -xvzf $UWS_GZ --strip-components=1 -C uWebSockets

[ ! -e $JSON_H ] && \
    wget https://github.com/nlohmann/json/releases/download/v$JSON_VERSION/json.hpp -O $JSON_H

