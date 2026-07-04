#!/bin/sh

set -e

DB_PASSWORD=$(cat /run/secrets/db_password)
WP_PASSWORD=$(cat /run/secrets/wp_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)

envsubst '$WP_PORT' < /etc/php82/php.fpm.d/www.conf.template > /etc/php82/php-fpm.d/www.conf

WP_PATH=/var/www/html

echo "Checking MariaDB connection..."
while ! nc -z mariadb ${DB_PORT}; do
	echo "Waiting for MariaDB network socket to open..."
	sleep 2
done

echo "Setting up Wordpress"

if [ ! -f $WP_PATH/wp-config.php ]; then
	echo "Downloading Wordpress..."
	wp core download --allow-root

	echo "Configuring Database connection parameters..."
	wp config create \
		--dbname=$DB_NAME \
		--dbuser=$DB_USER \
		--dbpass=$DB_PASSWORD \
		--dbhost=mariadb:$DB_PORT \
		--allow-root

	echo "Executing WordPress core installation..."
	wp core install \
		--url="https://$DOMAIN_NAME" \
		--title=$WP_TITLE \
		--admin_user=$WP_ADMIN_USER \
		--admin_password=$WP_ADMIN_PASSWORD \
		--admin_email="$WP_ADMIN_USER@42.fr" \
		--skip-email \
		--allow-root

	echo "Creating secondary user..."
	wp user create \
		$WP_USER \
		"$WP_USER@42.fr" \
		--role=author \
		--user_pass=$WP_PASSWORD \
		--allow-root

	chown -R www-data:www-data /var/www/html
	echo "WordPress service initialization completed successfully."
else
	echo "Wordpress already initialized"
fi

exec "$@"
