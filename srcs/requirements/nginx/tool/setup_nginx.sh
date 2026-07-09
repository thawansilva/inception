#!/bin/sh
set -e

envsubst '$WEB_PORT $DOMAIN_NAME $WP_PORT' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

if [ ! -f /etc/nginx/ssl/nginx.crt ]; then
	echo "Generating self-signed SSL certificate for $DOMAIN_NAME"
	openssl req -x509 \
		-newkey rsa:4096 \
		-keyout /etc/nginx/ssl/nginx.key \
		-out /etc/nginx/ssl/nginx.crt \
		-sha256 \
		-days 365 \
		-nodes \
		-subj "/C=BR/ST=SaoPaulo/L=SaoPaulo/O=42SaoPaulo/CN=$DOMAIN_NAME"

	chmod 600 /etc/nginx/ssl/nginx.key
	chmod 644 /etc/nginx/ssl/nginx.crt
	echo "SSL certificate generated at /etc/nginx/ssl"
else 
	echo "SSL certificate already exists."
fi

echo "Testing Nginx configuration..."
nginx -t
echo "Nginx configuration test passed"

echo "Starting Nginx..."
exec nginx -g "daemon off;"
