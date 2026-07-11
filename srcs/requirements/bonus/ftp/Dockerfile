FROM alpine:3.23

LABEL org.opencontainers.image.title="Inception - FTP" \
	org.opencontainers.image.description="FTP implementation for the Inception project" \
	org.opencontainers.image.authors="thaperei@student.42sp.org.br" \
	org.opencontainers.image.source="https://github.com/thawansilva/inception"

RUN apk update \
	&& apk add --no-cache vsftpd tini gettext-envsubst

COPY ./conf/vsftpd.conf /etc/vsftpd/vsftpd.conf.template
COPY ./tools/setup_ftp.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup_ftp.sh

EXPOSE 21 30000-30009

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/setup_ftp.sh"]
