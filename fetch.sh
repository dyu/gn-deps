#!/bin/sh

GTEST_VERSION=1.11.0
GTEST_GZ=target/googletest-$GTEST_VERSION.tar.gz

# legacy version
#SNAPPY_LEGACY_VERSION=1.1.4
#SNAPPY_LEGACY_GZ=target/snappy-$SNAPPY_LEGACY_VERSION.tar.gz

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

fetch_crc32c() {
[ ! -e crc32c ] && git clone --depth 1 --single-branch -b gn https://github.com/dyu/crc32c.git
}

#fetch_snappy_legacy() {
# https://github.com/google/snappy/releases/download/$SNAPPY_LEGACY_VERSION/snappy-$SNAPPY_LEGACY_VERSION.tar.gz has a different source!
#[ ! -e snappy/snappy.h ] && \
#    curl https://github.com/google/snappy/archive/$SNAPPY_LEGACY_VERSION.tar.gz -Lso $SNAPPY_LEGACY_GZ && \
#    tar -xvzf $SNAPPY_LEGACY_GZ --strip-components=1 -C snappy
#}

fetch_snappy() {
[ ! -e snappy ] && git clone --depth 1 --single-branch -b gn https://github.com/dyu/snappy.git
}

#fetch_leveldb_legacy() {
#[ ! -e leveldb-legacy/include ] && \
#    curl https://github.com/google/leveldb/archive/v$LEVELDB_LEGACY_VERSION.tar.gz -Lso $LEVELDB_LEGACY_GZ && \
#    tar -xvzf $LEVELDB_LEGACY_GZ --strip-components=1 -C leveldb-legacy && \
#    patch leveldb-legacy/port/port.h < leveldb-legacy/gn-diff/leveldb_port.diff && \
#    patch leveldb-legacy/include/leveldb/slice.h < leveldb-legacy/gn-diff/leveldb_slice.diff
#}

#leveldb
fetch_leveldb() {
[ ! -e leveldb ] && git clone --depth 1 --single-branch -b gn https://github.com/dyu/leveldb.git
}
fetch_leveldb_bp() {
[ ! -e leveldb-bp ] && git clone --depth 1 --single-branch -b gn-backport https://github.com/dyu/leveldb.git leveldb-bp
}
fetch_psldb() {
[ ! -e psldb ] && git clone --depth 1 --single-branch -b gn-log https://github.com/dyu/leveldb.git psldb
}

#hypereveldb
fetch_hyperleveldb() {
[ ! -e hyperleveldb ] && git clone --depth 1 --single-branch -b gn https://github.com/dyu/hyperleveldb.git
}
fetch_hyperleveldb_bp() {
[ ! -e hyperleveldb-bp ] && git clone --depth 1 --single-branch -b gn-backport https://github.com/dyu/hyperleveldb.git hyperleveldb-bp
}
fetch_pshdb() {
[ ! -e pshdb ] && git clone --depth 1 --single-branch -b gn-log https://github.com/dyu/hyperleveldb.git pshdb
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

fetch_zstd() {
[ ! -e zstd ] && git clone --depth 1 --single-branch -b gn https://github.com/dyu/zstd.git
}

fetch() {
    fetch_gtest
    fetch_crc32c
    fetch_snappy
    fetch_leveldb
    fetch_libuv
    fetch_uws
    fetch_json
    fetch_libpng
    fetch_zlib
    fetch_zstd
}

fetch_all() {
    fetch
    # leveldb variants
    fetch_leveldb_bp
    fetch_psldb
    # hyperleveldb variants
    fetch_hyperleveldb_bp
    fetch_pshdb
}

fetch_psdb() {
    fetch_gtest
    fetch_crc32c
    fetch_snappy
    fetch_libuv
    fetch_uws
    fetch_json
    
    fetch_psldb
    fetch_pshdb
}

fetch_arg() {
case "$1" in
    gtest)
    fetch_gtest
    ;;
    
    crc32c)
    fetch_crc32c
    ;;
    
    snappy)
    fetch_snappy
    ;;
    
    leveldb)
    fetch_leveldb
    ;;
    
    leveldb-bp)
    fetch_leveldb_bp
    ;;
    
    psldb)
    fetch_psldb
    ;;
    
    hyperleveldb)
    fetch_hyperleveldb
    ;;
    
    hyperleveldb-bp)
    fetch_hyperleveldb_bp
    ;;
    
    pshdb)
    fetch_pshdb
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
    
    zstd)
    fetch_zstd
    ;;
    
    psdb)
    fetch_psdb
    ;;
    
    all)
    fetch_all
    ;;
    
    *)
    echo "Unknown dependency: $1"
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
    fetch
fi

