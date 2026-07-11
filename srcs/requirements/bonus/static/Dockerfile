FROM alpine:3.23

LABEL org.opencontainers.image.title="Inception - Portfolio Website" \
	org.opencontainers.image.description="Static website implementation for the Inception project" \
	org.opencontainers.image.authors="thaperei@student.42sp.org.br" \
	org.opencontainers.image.source="https://github.com/thawansilva/inception"

RUN apk update \
	&& apk add --no-cache nginx tini gettext-envsubst

COPY ./conf/nginx.conf /etc/nginx/nginx.conf.template
COPY ./tools/setup_static.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/setup_static.sh

EXPOSE 8081

CMD ["/sbin/tini", "--", "/usr/local/bin/setup_static.sh"]
