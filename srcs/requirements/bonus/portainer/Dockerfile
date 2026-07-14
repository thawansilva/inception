FROM alpine:3.23

LABEL org.opencontainers.image.title="Inception - Portainer" \
	org.opencontainers.image.description="Portainer implementation for docker management" \
	org.opencontainers.image.authors="thaperei@student.42sp.org.br" \
	org.opencontainers.image.source="https://github.com/thawansilva/inception"

RUN apk update && apk add --no-cache curl wget tini gettext-envsubst

RUN curl -Lo /tmp/portainer.tar.gz \
	https://github.com/portainer/portainer/releases/download/2.21.0/portainer-2.21.0-linux-amd64.tar.gz \
	&& tar -xzf /tmp/portainer.tar.gz -C /usr/local/bin --strip-components=1 \
	&& rm /tmp/portainer.tar.gz


RUN mkdir -p /data

COPY ./tools/setup_portainer.sh /usr/local/bin/setup_portainer.sh
RUN chmod +x /usr/local/bin/setup_portainer.sh

EXPOSE 9443

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/setup_portainer.sh"]
