# Dockerfile

FROM python:3-stretch

ENV VERSION 1.16.243

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl git groff jq && \
    apt-get -y clean && apt-get -y autoclean && apt-get -y autoremove && \
    pip install --quiet --no-cache-dir awscli==${VERSION}

CMD ["aws"]
