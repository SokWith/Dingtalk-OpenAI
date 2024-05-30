FROM golang:1.18.10-alpine3.16 AS builder

# ENV GOPROXY      https://goproxy.io

RUN mkdir /app
ADD . /app/
WORKDIR /app
RUN go build -o chatgpt-dingtalk .

#FROM alpine:3.16
FROM node:alpine
ARG TZ="Asia/Shanghai"

#RUN apk update && apk upgrade \
#      && apk add python3 g++ make linux-headers openssl \
#      && wget https://nodejs.org/dist/v20.3.0/node-v20.3.0.tar.gz \
#      && tar xzvf node-v20.3.0.tar.gz \
#      && cd node-v20.3.0 \
#      && ./configure \
#      && make -j4 \
#      && make install

ENV TZ ${TZ}

RUN mkdir /app && apk upgrade \
    && apk add bash tzdata \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone

WORKDIR /app
COPY --from=builder /app/ .
RUN chmod +x chatgpt-dingtalk && cp config.example.yml config.yml

CMD ./chatgpt-dingtalk
