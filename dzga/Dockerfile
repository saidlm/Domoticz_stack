FROM python:alpine

RUN \
  echo "**** install build packages ****" && \
  apk update --no-cache && \
  apk add --no-cache --virtual=build-dependencies git

RUN \
  echo "**** building dzga ****" && \
  git clone https://github.com/DewGew/Domoticz-Google-Assistant.git --branch master /tmp/dzga && \
  cd /tmp/dzga && \
  cp *.py / && \
  cp -r templates/ /templates/ && \
  cp -r static/ /static/ && \
  pip install --no-cache-dir -r ./requirements/pip-requirements.txt && \
  apk del --purge build-dependencies && \
  echo "**** cleanup ****" && \
  rm -rf /tmp/* && \
  mkdir -p /config 
  
# Create volume
VOLUME /config

# Configure Services and Port
CMD ["python3", "/__main__.py"]

EXPOSE 3030
