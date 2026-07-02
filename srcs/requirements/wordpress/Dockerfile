FROM alpine:3.23

LABEL org.opencontainers.image.title="Inception - WordPress + PHP-FPM" \
	org.opencontainers.image.description="Implement Wordpress + PHP-FPM application for the Inception project" \
	org.opencontainers.image.authors="thaperei@student.42sp.org.br" \
	org.opencontainers.image.source="https://github.com/thawansilva/inception"

RUN apk update \
	&& apk add --no-cache \
	php82 \
	php82-fpm \
	php82-mysqli \
	php82-json \
	php82-openssl \
	php82-curl \
	php82-zlib \
	php82-xml \
	php82-phar \
	php82-iconv \
	mariadb-client \
	curl \
	gettext-envsubst \
	tini \
	&& ln -s /usr/bin/php82 /usr/bin/php \

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

WORKDIR /var/www/html

COPY ./conf/www.conf /etc/php82/php.fpm.d/www.conf.template
COPY ./tools/setup_wordpress.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup_wordpress.sh

EXPOSE 9000

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/setup_wordpress.sh"]
