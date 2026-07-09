#!/bin/sh

set -e

envsubst '$DB_PORT' < /etc/mariadb-server.cnf.template > /etc/my.cnf.d/mariadb-server.cnf

DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
DB_PASSWORD=$(cat /run/secrets/db_password)

DB_DATADIR=/var/lib/mysql

if [ ! -d "$DB_DATADIR/mysql" ]; then
	echo "Initializing MariaDB configuration"

	mariadb-install-db --user=mysql --datadir="$DB_DATADIR" > /dev/null

	echo "Setting up MariaDB"
	cat << EOF > /tmp/init.sql

FLUSH PRIVILEGES;

ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS ${DB_NAME};

CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';

CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

	echo "Executing bootstrap configuration..."
	mariadbd -u mysql --datadir="$DB_DATADIR" --bootstrap < /tmp/init.sql

	rm -fr /tmp/init.sql
	echo "MariaDB configuration bootstrap completed successfully..."

else
	echo "MariaDB storage directory already created. Skipping bootstrap."
fi

echo "Starting MariaDB engine..."
exec mariadbd --user=mysql --datadir=${DB_DATADIR} --console
