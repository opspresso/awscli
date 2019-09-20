# Dockerfile

FROM python:3-stretch

ENV VERSION 1.16.242

ENV DOCKER_VERSION 18.06.1-ce

ENV HAPTIO_VERSION 0.3.0

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl groff jq && \
    apt-get -y clean && apt-get -y autoclean && apt-get -y autoremove && \
    curl -fsSLO https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v${HAPTIO_VERSION}/heptio-authenticator-aws_${HAPTIO_VERSION}_linux_amd64 && \
    mv heptio-authenticator-aws_${HAPTIO_VERSION}_linux_amd64 /usr/local/bin/aws-iam-authenticator && \
    chmod +x /usr/local/bin/aws-iam-authenticator && \
    curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz && \
    tar xzvf docker-${DOCKER_VERSION}.tgz --strip 1 -C /usr/local/bin docker/docker && \
    rm docker-${DOCKER_VERSION}.tgz && \
    rm -rf /var/lib/apt/lists/* && \
    pip install --upgrade pip && \
    pip install --upgrade awscli==${VERSION} && \
    rm /var/cache/apk/*

COPY "entrypoint.sh" "/entrypoint.sh"
ENTRYPOINT ["/entrypoint.sh"]
CMD ["help"]
