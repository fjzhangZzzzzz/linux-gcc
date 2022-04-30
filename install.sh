#!/bin/bash

set -xe

function get_pkg_name() {
  local path="$1"
  echo ${path##*/}
}

function get_dir_name() {
  local pkg=$1
  echo ${pkg%%.tar*}
}

function check_pkg() {
  local pkg=$1
  local url=$2
  local dir=$3

  if [[ ! -f $pkg ]]; then
    wget $url
  fi

  if [[ ! -d $dir ]]; then
    tar -xf $pkg
  fi
}

WORK_DIR='/tmp/.install_dist'

DIST_BINUTILS_URL='http://ftp.gnu.org/gnu/binutils/binutils-2.27.tar.gz'
DIST_BINUTILS_PKG=$(get_pkg_name $DIST_BINUTILS_URL)
DIST_BINUTILS_DIR=$(get_dir_name $DIST_BINUTILS_PKG)

DIST_GCC_URL='http://ftp.gnu.org/gnu/gcc/gcc-4.9.4/gcc-4.9.4.tar.gz'
DIST_GCC_PKG=$(get_pkg_name $DIST_GCC_URL)
DIST_GCC_DIR=$(get_dir_name $DIST_GCC_PKG)

DIST_GDB_URL='http://ftp.gnu.org/gnu/gdb/gdb-7.12.tar.xz'
DIST_GDB_PKG=$(get_pkg_name $DIST_GDB_URL)
DIST_GDB_DIR=$(get_dir_name $DIST_GDB_PKG)

# 安装依赖
yum install -y wget bzip2 texinfo file make gcc gcc-c++

[[ ! -d $WORK_DIR ]] && mkdir -p $WORK_DIR || ls -A $WORK_DIR

cd $WORK_DIR

# 下载源码包并解压
check_pkg $DIST_BINUTILS_PKG $DIST_BINUTILS_URL $DIST_BINUTILS_DIR
check_pkg $DIST_GCC_PKG $DIST_GCC_URL $DIST_GCC_DIR
check_pkg $DIST_GDB_PKG $DIST_GDB_URL $DIST_GDB_DIR

# 下载 GCC 依赖包
cd $WORK_DIR && tar -xf $DIST_GCC_PKG && \
  chmod u+x $DIST_GCC_DIR/contrib/download_prerequisites && \
  cd $DIST_GCC_DIR && ./contrib/download_prerequisites

# 编译 binutils
cd $WORK_DIR/$DIST_BINUTILS_DIR && ./configure && make && make install

# 编译 gcc
cd $WORK_DIR/$DIST_GCC_DIR && \
  ./configure --enable-checking=release --enable-languages=c,c++ \
              --disable-multilib --enable-libstdcxx-allocator --enable-threads \
              --enable-libstdcxx-threads --enable-long-long --enable-threads=posix \
              --enable-tls --enable-libsanitizer --enable-default-pie --enable-default-ssp && \
  make && make install

# 编译 gdb
cd $WORK_DIR/$DIST_GDB_DIR && ./configure && make && make install
