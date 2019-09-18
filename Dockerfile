# Dockerfile

FROM alpine

RUN apk -v --update add bash curl python3 python3-dev groff less mailcap ca-certificates

ENV VERSION 1.16.241

RUN pip3 install --upgrade awscli==${VERSION} && \
    rm /var/cache/apk/*

ENTRYPOINT ["bash"]
