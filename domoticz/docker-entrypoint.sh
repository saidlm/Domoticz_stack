#!/bin/bash
set -e
DATA_DIR=${DATA_DIR}

# copy default scripts
if [ ! -e $DATA_DIR/scripts ]; then 
  echo "Populating defaul scripts ..."
  cp -r /opt/domoticz/scripts $DATA_DIR
fi

# generate ssl certificate
mkdir -p $DATA_DIR/keys

if [ ! -e /config/keys/server_cert.pem ]; then
  echo "Creating SSL certificate ..." 
  if [ -e /config/keys/RSA2048.pem ]; then
    rm /config/keys/RSA2048.pem
  fi
  openssl dhparam -out /config/keys/RSA2048.pem -5 2048
  openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 -keyout /config/keys/server_cert.pem  -out /config/keys/server_cert.pem \
    -subj "/CN=domoticz"
  cat /config/keys/RSA2048.pem >> /config/keys/server_cert.pem
fi

echo "Starting domoticz ..."
if [ $1 == "/opt/domoticz/domoticz" ]; then
  echo "11111111111111111111111"
  exec $@ -approot /opt/domoticz/ -userdata /config/ -noupdate 
else
  echo "222222222222222222222222222"
  exec "$@"
fi
