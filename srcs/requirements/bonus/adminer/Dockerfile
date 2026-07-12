FROM alpine:3.23

LABEL org.opencontainers.image.title="Inception - Adminer" \
	org.opencontainers.image.description="Database management implementation for the Inception project" \
	org.opencontainers.image.authors="thaperei@student.42sp.org.br" \
	org.opencontainers.image.source="https://github.com/thawansilva/inception"

RUN apk update && apk add --no-cache curl nginx tini gettext-envsubst

RUN mkdir -p /var/www/adminer

RUN curl -Lo /var/www/adminer/index.php \
	https://github.com/vrana/adminer/releases/download/v5.4.4/adminer-5.4.4.php

COPY ./conf/nginx.conf /etc/nginx/nginx.conf.template
COPY ./tools/setup_adminer.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/setup_adminer.sh

EXPOSE 9001

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/setup_adminer.sh"]
