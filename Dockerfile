# Dockerfile

FROM alpine

RUN apk -v --update add bash curl python py-pip groff less mailcap ca-certificates

ENV VERSION 0.0.0
RUN pip install --upgrade awscli==${VERSION} && \
    apk -v --purge del py-pip && \
    rm /var/cache/apk/*

ENTRYPOINT ["bash"]
