FROM alpine:3.23

LABEL org.opencontainers.image.title="Inception - Portainer" \
	org.opencontainers.image.description="Portainer implementation for Docker management" \
	org.opencontainers.image.authors="thaperei@student.42sp.org.br" \
	org.opencontainers.image.source="https://github.com/thawansilva/inception"

RUN apk update && apk add --no-cache nginx openssl tini gettext-envsubst

EXPOSE 9443
