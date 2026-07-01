FROM alpine:3.23

LABEL org.opencontainers.image.title="Inception - WordPress + PHP-FPM" \
	org.opencontainers.image.description="Implement Wordpress + PHP-FPM application for the Inception project" \
	org.opencontainers.image.authors="thaperei@student.42sp.org.br" \
	org.opencontainers.image.source="https://github.com/thawansilva/inception"

RUN apk update \
	&& apk add --no-cache php82 \
	php82-fpm \
	php82-mysqli \
	php82-json \
	php82-openssl \
	php82-curl \
	php82-zlib \
	php82-xml \
	curl \
	gettext-envsubst \
	&& ln -s /usr/sbin/php-fpm8.2 /usr/local/bin/php-fpm

COPY ./conf/worpress.conf /etc/wordpress.cnf.template
COPY ./tools/setup_wordpress.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/setup_wordpress.sh

EXPOSE 9000

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/setup_wordpress.sh"]
