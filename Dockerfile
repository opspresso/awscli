# Dockerfile

FROM alpine

RUN apk -v --update add python jq py-pip groff less mailcap bash ca-certificates

ENV VERSION 1.16.111
RUN pip install --upgrade awscli==${VERSION} && \
    apk -v --purge del py-pip && \
    rm /var/cache/apk/*

ENTRYPOINT ["bash"]
