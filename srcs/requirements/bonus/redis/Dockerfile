FROM alpine:3.23

LABEL org.opencontainers.image.title="Inception - Redis" \
	org.opencontainers.image.description="Redis implementation for the Inception project" \
	org.opencontainers.image.authors="thaperei@student.42sp.org.br" \
	org.opencontainers.image.source="https://github.com/thawansilva/inception"

RUN apk update \
	&& apk add --no-cache redis tini gettext-envsubst

RUN mkdir -p /var/log/redis && chown redis:redis /var/log/redis

COPY ./conf/redis.conf /etc/redis/redis.conf.template
COPY ./tools/setup_redis.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/setup_redis.sh

EXPOSE 6379

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/setup_redis.sh"]
