# Dockerfile

FROM alpine

RUN apk -v --update add python py-pip groff less mailcap bash perl

ENV VERSION 1.15.82
RUN pip install --upgrade awscli==${VERSION} && \
    apk -v --purge del py-pip && \
    rm /var/cache/apk/*

ENTRYPOINT ["bash"]
