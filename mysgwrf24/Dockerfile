FROM alpine:3.12

# set version label
MAINTAINER Martin Saidl, martin.saidl@tone.cz

RUN \
  echo "**** install build packages ****" && \
  apk update --no-cache && \
  apk add --no-cache --virtual=build-dependencies \
	bash \
        autoconf \
        automake \
        binutils \
        gcc \
        g++ \
        git \
        make \
        linux-headers \ 
        libc-dev && \
  echo "**** building MySgwRF24 ****" && \
  git clone https://github.com/mysensors/MySensors.git --branch master /tmp/mysgw && \
  cd /tmp/mysgw && \
  echo "**** building version: $(cat library.properties | grep version | cut -d= -f2)-$(git describe --tags) ****" && \
  LDFLAGS="-static" ./configure \
        --soc=BCM2835 \
        --cpu-flags="-mcpu=cortex-a53 -mtune=cortex-a53 -mfloat-abi=hard -mfpu=neon-fp-armv8 -mneon-for-64bits" \
        --spi-driver=BCM \
        --my-transport=rf24 \
        --my-rf24-channel=95 \
        --my-rf24-ce-pin=24 \
        --my-rf24-cs-pin=22 \
        --my-rf24-irq-pin=18 \
        --my-gateway=ethernet \
        --my-port=5003 \
        --my-config-file=/data/mysensors-rf24.conf && \
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

