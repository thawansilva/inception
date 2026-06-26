#!/bin/sh

set -e

DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password.txt)
DB_PASSWORD=$(cat /run/secrets/db_password.txt)
DB_USER=$(cat /run/secrets/db_user.txt)

DATADIR=/var/lib/mysql

if [ ! -d "$DATADIR/mysql" ]; then
	echo "Initializing MariaDB configuration"

	mariadb-install-db --user=mysql --datadir="$DATADIR"
	TMP_FILE="/tmp/init_db.sql"

	cat << EOF > $TMP_FILE
FLUSH PRIVILEGES;

ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
CREATE USER IF NOT EXISTS 'root'@'127.0.0.1' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
GRANT ALL PRIVILEGES ON  *.* TO 'root'@'127.0.0.1' WITH GRANT OPTION;

CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

	mariadbd --user=mysql --datadir="$DATADIR" --bootstrap < $TMP_FILE
	rm -f $TMP_FILE

	echo "MariaDB configuration completed"
else
	echo "Mariadb storage already initialized"
fi

exec mariadbd --user=mysql --datadir="$DATADIR" --console
