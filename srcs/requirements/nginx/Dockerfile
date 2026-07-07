FROM alpine:3.23

LABEL org.opencontainers.image.title="Inception - NGINX" \
	org.opencontainers.image.description="Implement NGINX for the Inception project" \
	org.opencontainers.image.authors="thaperei@student.42sp.org.br" \
	org.opencontainers.image.source="https://github.com/thawansilva/inception"

RUN apk update && apk add --no-cache nginx openssl tini gettext-envsubst

RUN mkdir -p /etc/nginx/ssl

COPY ./conf/nginx.conf /etc/nginx/ssl/nginx.conf.template
COPY ./tool/setup_nginx.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/setup_nginx.sh

EXPOSE 443

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/setup_nginx.sh"]
