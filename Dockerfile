# Dockerfile

FROM python:slim

RUN apt-get update && \
    apt-get install -y git curl zip jq && \
    pip install awscli

ENTRYPOINT ["bash"]
