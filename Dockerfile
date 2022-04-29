FROM centos:7
WORKDIR /root/dist/
ADD http://ftp.gnu.org/gnu/binutils/binutils-2.27.tar.gz /root/dist/
ADD http://ftp.gnu.org/gnu/gcc/gcc-4.9.4/gcc-4.9.4.tar.gz /root/dist/
ADD http://ftp.gnu.org/gnu/gdb/gdb-7.12.tar.xz /root/dist/
RUN yum install -y wget bzip2 make gcc gcc-c++
RUN cd /root/dist && tar xzf gcc-4.9.4.tar.gz && chmod u+x gcc-4.9.4/contrib/download_prerequisites
RUN cd /root/dist/gcc-4.9.4 && ./contrib/download_prerequisites
RUN cd /root/dist && tar xzf binutils-2.27.tar.gz && cd binutils-2.27 && ./configure && make && make install
RUN cd /root/dist && mkdir -p build_gcc-4.9.4 && cd build_gcc-4.9.4 && ../gcc-4.9.4/configure --enable-checking=release --enable-languages=c,c++ --disable-multilib --enable-libstdcxx-allocator --enable-threads --enable-libstdcxx-threads --enable-long-long --enable-threads=posix --enable-tls --enable-libsanitizer --enable-default-pie --enable-default-ssp
RUN cd /root/dist/build_gcc-4.9.4 && make && make install
RUN cd /root/dist && xz -d gdb-7.12.tar.xz && tar xf gdb-7.12.tar && cd gdb-7.12 && ./configure && make && make install
CMD ["/bin/sh"]
