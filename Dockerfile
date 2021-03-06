FROM boot2docker/boot2docker
MAINTAINER Charlie Lewis <clewis@iqt.org>

# install perl5 for git submodules
RUN curl -L -o /tmp/perl5.tcz $TCL_REPO_BASE/tcz/perl5.tcz \
    && unsquashfs -f -d $ROOTFS /tmp/perl5.tcz \
    && rm -rf /tmp/perl5.tcz

ADD vent $ROOTFS/vent/
ADD scripts $ROOTFS/scripts/
ADD vendor $ROOTFS/vendor/
ADD motd $ROOTFS/etc/motd
RUN echo "built on $(date)" >> $ROOTFS/vent/VERSION
RUN echo "echo \"vent \$(cat /vent/VERSION)\"" >> $ROOTFS/etc/profile.d/boot2docker.sh
RUN cat $ROOTFS/scripts/custom >> $ROOTFS/etc/profile.d/boot2docker.sh

# install dependencies
WORKDIR /tmp
RUN mkdir -p $ROOTFS/usr/local/share/man/man1
RUN tar xf $ROOTFS/vendor/tinycore-python2/python2.tar
WORKDIR /tmp/tmp/python2
RUN mv python2.7.1 $ROOTFS/usr/local/share/man/man1/python2.7.1
RUN mv libpython2.7.so.1.0 $ROOTFS/usr/local/lib/libpython2.7.so.1.0
RUN mv libpython2.7.so $ROOTFS/usr/local/lib/libpython2.7.so
RUN mv python-2.7.pc $ROOTFS/usr/local/lib/pkgconfig/python-2.7.pc
RUN mv python2.7-config $ROOTFS/usr/local/bin/python2.7-config
RUN mv python2.7 $ROOTFS/usr/local/bin/python2.7
RUN tar xf python.tar \
    && mv python2.7 $ROOTFS/usr/local/lib/python2.7
RUN tar xf python-include.tar \
    && mv python2.7 $ROOTFS/usr/local/include/python2.7
RUN echo "TERM=xterm LANG=C.UTF-8 /usr/local/bin/python2.7 /vent/menu_launcher.py" >> $ROOTFS/usr/local/bin/vent-cli
RUN chmod +x $ROOTFS/usr/local/bin/vent-cli
RUN rm -rf $ROOTFS/vendor/tinycore-python2
RUN chmod -R 777 $ROOTFS/vent/plugins
RUN chmod -R 777 $ROOTFS/vent/templates

RUN /make_iso.sh
CMD ["cat", "/boot2docker.iso"]
