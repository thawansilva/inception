FROM alpine:3.23

LABEL org.opencontainers.image.title="Inception - WordPress + PHP-FPM" \
	org.opencontainers.image.description="Implement Wordpress + PHP-FPM application for the Inception project" \
	org.opencontainers.image.authors="thaperei@student.42sp.org.br" \
	org.opencontainers.image.source="https://github.com/thawansilva/inception"

RUN apk update && apk add --no-cache \
	php83 \
	php83-fpm \
	php83-mysqli \
	php83-json \
	php83-openssl \
	php83-curl \
	php83-zlib \
	php83-xml \
	php83-phar \
	php83-iconv \
	php83-tokenizer \
	mariadb-client \
	curl \
	gettext-envsubst \
	tini && ln -s /usr/bin/php83 /usr/bin/php

RUN echo "memory_limit=512M" > /etc/php83/conf.d/memory_limit.ini

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

WORKDIR /var/www/html

COPY ./conf/www.conf /etc/php83/php.fpm.d/www.conf.template
COPY ./tools/setup_wordpress.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup_wordpress.sh

EXPOSE 9000

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/setup_wordpress.sh"]
