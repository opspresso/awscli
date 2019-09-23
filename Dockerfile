# Dockerfile

FROM alpine

ENV VERSION 1.16.243

RUN apk -v --update add bash curl python py-pip groff less mailcap jq

RUN pip install --upgrade awscli==${VERSION} python-magic && \
    apk -v --purge del py-pip && \
    rm /var/cache/apk/*

VOLUME /root/.aws

ENTRYPOINT ["aws"]
