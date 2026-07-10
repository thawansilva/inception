#!/bin/sh

set -e

FTP_PASSWORD=$(cat /run/secrets/ftp_password)

mkdir -p /var/run/vsftpd/empty

envsubst '$FTP_PORT $FTP_PASV_MIN_PORT $FTP_PASV_MAX_PORT' < /etc/vsftpd/vsftpd.conf.template > /etc/vsftpd/vsftpd.conf

if ! id "$FTP_USER" > /dev/null 2>&1; then
	echo "Adding user '$FTP_USER'..."
	adduser -D -h /var/www/html "$FTP_USER"
	echo "Creating a password for the user..."
	echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
fi

exec vsftpd /etc/vsftpd/vsftpd.conf
