#!/bin/sh

set -e

envsubst '$DB_PORT' < /etc/mariadb-server.cnf.template > /etc/my.cnf.d/mariadb-server.cnf

DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
DB_PASSWORD=$(cat /run/secrets/db_password)

DB_DATADIR=/var/lib/mysql

if [ ! -d "$DB_DATADIR/mysql" ]; then
	echo "Initializing MariaDB configuration"

	mariadb-install-db --user=mysql --datadir="$DB_DATADIR" > /dev/null
fi

echo "Starting temporary MARIADB Instance"
mysqld --skip-networking --user=mysql --socket=/run/mysqld/mysqld.sock & pid="$!"

echo "Waiting for MariaDB to be ready..."
until mysqladmin --socket=/run/mysqld/mysqld.sock ping >/dev/null 2>&1; do
	sleep 1
done
echo "MariaDB is ready"

echo "Setting up MariaDB"

echo senha $DB_PASSWORD

mysql --socket=/run/mysqld/mysqld.sock -u root << EOF
FLUSH PRIVILEGES;

ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS ${DB_NAME};

CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

echo "Shutting down temporary MariaDB..."
mysqladmin --socket=/run/mysqld/mysqld.sock -u root -p"${DB_ROOT_PASSWORD}" shutdown

# Wait for shutdown
wait "$pid" || true

echo "MariaDB configuration completed. Starting MariaDB..."
exec mysqld --user=mysql --datadir=/var/lib/mysql --socket=/run/mysqld/mysqld.sock
