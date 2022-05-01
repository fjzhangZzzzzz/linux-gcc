#!/bin/bash

set -xe

yum -y install rpm-build rpm-devel rpmdevtools wget bzip2 texinfo file make gcc gcc-c++

[ ! -d ~/rpmbuild ] && rpmdev-setuptree || true

cp $1.spec ~/rpmbuild/SPECS 

cd ~/rpmbuild/SOURCES
if [ "$1" == "binutils" ]; then
  [ ! -f binutils-2.27.tar.gz ] && wget http://ftp.gnu.org/gnu/binutils/binutils-2.27.tar.gz || true
elif [ "$1" == "gcc" ]; then
  [ ! -f gcc-4.9.4.tar.gz ] && wget http://ftp.gnu.org/gnu/gcc/gcc-4.9.4/gcc-4.9.4.tar.gz || true
elif [ "$1" == "gdb" ]; then
  [ ! -f gdb-7.12.tar.xz ] && wget http://ftp.gnu.org/gnu/gdb/gdb-7.12.tar.xz || true
else
  echo "unknown: $1"
  exit 1
fi

rpmbuild -ba ~/rpmbuild/SPECS/$1.spec
