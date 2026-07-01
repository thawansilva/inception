FROM alpine:3.23

LABEL org.opencontainers.image.title="Inception - MariaDB" \
	org.opencontainers.image.description="Customizable Database for the Inception project" \
	org.opencontainers.image.authors="thaperei@student.42sp.org.br" \
	org.opencontainers.image.source="https://github.com/thawansilva/inception"

RUN apk update \
	&& apk add --no-cache mariadb mariadb-client tini gettext-envsubst

RUN mkdir -p /var/run/mysqld \
	&& chown -R mysql:mysql /var/run/mysqld \
	&& chmod 755 /var/run/mysqld

COPY ./conf/mariadb.conf /etc/mariadb-server.cnf.template
COPY ./tools/init_db.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/init_db.sh

EXPOSE 3306

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/init_db.sh"]
