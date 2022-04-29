FROM centos:5.11
ADD http://ftp.gnu.org/gnu/binutils/binutils-2.27.tar.gz /root/dist/
ADD http://ftp.gnu.org/gnu/gcc/gcc-4.9.4/gcc-4.9.4.tar.gz /root/dist/
ADD http://ftp.gnu.org/gnu/gdb/gdb-7.12.tar.xz /root/dist/
RUN cd /root/dist && tar xvzf binutils-2.27.tar.gz && cd binutils-2.27 && ./configure && make && make install
RUN cd /root/dist && tar xvzf gcc-4.9.4.tar.gz && cd gcc-4.9.4 && ./contrib/download_prerequisites && mkdir -p ../build_gcc-4.9.4 && cd ../build_gcc-4.9.4 && ../gcc-4.9.4/configure --enable-checking=release --enable-languages=c,c++ --disable-multilib --enable-libstdcxx-allocator --enable-threads --enable-libstdcxx-threads --enable-long-long --enable-threads=posix --enable-tls --enable-libsanitizer --enable-default-pie --enable-default-ssp && make && make install
RUN cd /root/dist && xz -d gdb-7.12.tar.xz && tar xvf gdb-7.12.tar && cd gdb-7.12 && ./configure && make && make install
CMD ["/bin/sh"]
