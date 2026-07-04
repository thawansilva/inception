#!/bin/sh

set -e

DB_PASSWORD=$(cat /run/secrets/db_password)
WP_PASSWORD=$(cat /run/secrets/wp_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)

envsubst '$WP_PORT' < /etc/php83/php.fpm.d/www.conf.template > /etc/php83/php-fpm.d/www.conf

WP_PATH=/var/www/html
HASH_FILE=$WP_PATH/.config_hash

HASH_CONFIG=$(printf '%s' "$DB_NAME" "$DB_USER" "$DB_PASSWORD" "$WP_USER" "$WP_PASSWORD" \
	"$WP_ADMIN_USER" "$WP_ADMIN_PASSWORD" "$WP_PORT" "$DOMAIN_NAME" | sha256sum | \
	cut -d ' ' -f1
)

apply_wp_config () {
	wp config set DB_NAME "$DB_NAME" --allow-root
	wp config set DB_USER "$DB_USER" --allow-root
	wp config set DB_PASSWORD "$DB_PASSWORD" --allow-root
	wp config set DB_HOST "mariadb:$DB_PORT" --allow-root
}

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

	apply_wp_config

	chown -R nobody:nobody /var/www/html
	echo $HASH_CONFIG > $HASH_FILE

	echo "WordPress service initialization completed successfully."
else
	STORED_HASH=""
	[ -f $HASH_FILE ] && STORED_HASH=$(cat $HASH_FILE)

	if [ $HASH_CONFIG != $STORED_HASH ]; then
		apply_wp_config
		echo $HASH_CONFIG > $HASH_FILE
	fi

	echo "Wordpress already initialized"
	chown -R nobody:nobody /var/www/html
	mkdir -p /var/www/html/wp-content/uploads
	chmod -R 775 /var/www/html/wp-content/uploads
fi

exec php-fpm83 -F
