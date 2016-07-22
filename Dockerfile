FROM nginx:alpine

MAINTAINER Lyndon "snakeliwei@gmail.com"

WORKDIR /root

ENV DOCKER_GEN_VERSION '0.7.3'
ENV S6_OVERLAY_VERSION 'v1.18.1.3'

ADD https://github.com/just-containers/s6-overlay/releases/download/$S6_OVERLAY_VERSION/s6-overlay-amd64.tar.gz /tmp/
ADD https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-alpine-linux-amd64-$DOCKER_GEN_VERSION.tar.gz /tmp/
ADD https://raw.githubusercontent.com/diafygi/acme-tiny/fcb7cd6f66e951eeae76ff2f48d8ad3e40da37ef/acme_tiny.py /bin/acme_tiny

RUN apk --update add python ruby cron tar tzdata && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    apk del tzdata && \
    rm -rf /var/cache/apk/* && \
    tar xzf /tmp/s6-overlay-amd64.tar.gz -C / &&\
    tar -C /bin -xzf /tmp/docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz && \
    rm /tmp/docker-gen-linux-amd64-$DOCKER_GEN_VERSION.tar.gz && \
    rm /tmp/s6-overlay-amd64.tar.gz && \
    rm /etc/nginx/conf.d/default.conf

COPY ./fs_overlay /

RUN chmod a+x /bin/* && \
    chmod a+x /etc/cron.weekly/renew_certs

VOLUME /var/lib/https-portal

ENTRYPOINT ["/init"]
