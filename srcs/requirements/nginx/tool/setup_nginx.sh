#!/bin/sh
set -e

if [ ! -f /etc/nginx/ssl/nginx.crt ]; then
	echo "Generating self-signed SSL certificate for $DOMAIN_NAME"
else 
	echo "SSL certificate already exists."
fi

nginx -t
echo "Nginx configuration test passed"
