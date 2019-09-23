# Dockerfile

FROM alpine

RUN apk add -v --update bash curl python py-pip groff less mailcap jq

ENV VERSION 1.16.243

RUN pip install --upgrade awscli==${VERSION} && \
    apk del -v --purge py-pip && \
    rm /var/cache/apk/*

VOLUME /root/.aws

ENTRYPOINT ["aws"]
