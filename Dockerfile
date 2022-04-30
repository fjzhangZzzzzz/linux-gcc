FROM centos:7
ADD install.sh /tmp/
RUN /bin/bash /tmp/install.sh
CMD ["/bin/sh"]
