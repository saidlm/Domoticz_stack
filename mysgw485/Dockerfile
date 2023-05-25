FROM alpine:latest

# set version label
MAINTAINER Martin Saidl, martin.saidl@tone.cz

RUN \
  echo "**** install build packages ****" && \
  apk update --no-cache && \ 
  apk add --no-cache --virtual=build-dependencies \
        autoconf \
        automake \
        binutils \
        gcc \
        g++ \
        git \
        make \
        linux-headers \ 
        libc-dev && \
  echo "**** building MySgw485 ****" && \
  git clone https://github.com/mysensors/MySensors.git --branch master /tmp/mysgw && \
  cd /tmp/mysgw && \
  echo "**** building version: $(cat library.properties | grep version | cut -d= -f2)-$(git describe --tags) ****" && \
  LDFLAGS="-static" ./configure \
        --my-transport=rs485 \
        --my-rs485-serial-port=/dev/ttyMYSGW \
        --my-gateway=ethernet \
        --my-port=5003 \
        --my-rs485-baudrate=19200 \
        --my-config-file=/data/mysensors-rs485.conf && \
  make && \
  cp /tmp/mysgw/bin/mysgw / && \
  echo "**** cleanup ****" && \
  apk del --purge \
        build-dependencies && \
  rm -rf \
        /tmp/*
 
EXPOSE 5003
VOLUME /data
ENTRYPOINT ["/mysgw", "-q"]
