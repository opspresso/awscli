# Dockerfile

FROM alpine

RUN apk add -v --update bash curl python py-pip jq git file

ENV VERSION 2.0.37

RUN pip install --upgrade awscli==${VERSION} && \
    apk del -v --purge py-pip && \
    rm /var/cache/apk/*

VOLUME /root/.aws

ENTRYPOINT ["aws"]
