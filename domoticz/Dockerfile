FROM debian:bullseye-slim

# set version label
LABEL maintainer="martin.saidl@tone.cz"

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"
WORKDIR /opt/domoticz
ENV DATA_DIR="/config"
ENV HOME=${DATA_DIR}

RUN echo "**** install debian basic packages ****" && \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y --no-install-recommends \
    ca-certificates \
    tzdata \
    gnupg2 \
    git \
    curl \
    wget && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo "**** install domoticz required runtime packages ****" && \ 
  apt-get update && \
  apt-get install -y --no-install-recommends \
    libcap2-bin \
    libcurl3-gnutls \
    libcurl4 \
    libpython3.9 \
    libudev-dev \
    libusb-0.1-4 \
    libsqlite3-0 \
    mosquitto-clients \
    python3-pip \
    python3-requests \
    unzip \
    zlib1g \
    openssh-client \
    jq \
    jo \
    php-cgi \
    libjpeg62-turbo \
    uvccapture && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  pip3 install \
    setuptools \
    requests \
    pymodbus
  

RUN echo "**** install domoticz ****" && \ 
  OS="$(uname -s | sed 'y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/')" && \
  MACH=$(uname -m) && \
  if [ ${MACH} = "armv6l" ]; then MACH = "armv7l"; fi && \
  archive_file="domoticz_${OS}_${MACH}.tgz" && \
  version_file="version_${OS}_${MACH}.h" && \
  history_file="history_${OS}_${MACH}.txt" && \
  curl -k -L https://releases.domoticz.com/releases/release/${archive_file} -o /tmp/domoticz.tgz && \
  tar xfz /tmp/domoticz.tgz && \
  mkdir -p /config && \
  if [ ${MACH} = "armv7l" ]; then \
    ln -s /usr/lib/arm-linux-gnueabihf/libpython3.9.so.1 /usr/lib/arm-linux-gnueabihf/libpython3.9.so; \
  else \
    ln -s /usr/lib/x86_64-linux-gnu//libpython3.9.so.1 /usr/lib/x86_64-linux-gnu//libpython3.9.so; \
  fi && \
  rm -rf /tmp/* /var/tmp/*

RUN echo "**** set up environment ****" &&\
  echo "**** add user domoticz ****" && \
  useradd -d /config domoticz && \
  echo "**** add groups to access hardware ****" && \
  groupadd -g 997 gpio && \  
  groupadd -g 998 i2c && \  
  groupadd -g 999 spi && \  
  echo "**** add domoticz to appropriate groups ****" && \
  usermod -a -G dialout,gpio,i2c,spi domoticz && \
  chown -R domoticz.users /config/

# copy local files
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# expose ports
EXPOSE 1443 6144 8080

# set volume
VOLUME [${DATA_DIR}]

USER domoticz

# entrypoint
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/opt/domoticz/domoticz"]
