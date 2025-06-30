FROM python:3.11-alpine AS builder

RUN apk add --no-cache build-base linux-headers
WORKDIR /build-area
COPY base-requirements.txt .


RUN pip wheel --no-cache-dir --wheel-dir=/wheels -r base-requirements.txt


FROM python:3.11-alpine

RUN apk add --no-cache openjdk17-jre bash

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk
ENV SPARK_HOME=/usr/local/lib/python3.11/site-packages/pyspark
ENV PATH=$PATH:$JAVA_HOME/bin:$SPARK_HOME/bin

COPY --from=builder /wheels /wheels

RUN pip install --no-cache-dir /wheels/*

WORKDIR /app

CMD ["jupyter", "--version"]
