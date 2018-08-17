# Dockerfile

FROM python:slim

RUN apt-get update && \
    apt-get install -y curl zip

RUN curl -sLO https://s3.amazonaws.com/aws-cli/awscli-bundle.zip && \
    unzip awscli-bundle.zip && rm -rf awscli-bundle.zip && \
    ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

ENTRYPOINT ["bash"]
