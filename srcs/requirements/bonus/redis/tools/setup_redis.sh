#!/bin/sh

set -e

envsubst '$REDIS_PORT' < /etc/redis/redis.conf.template > /etc/redis/redis.conf

echo "Starting redis server..."
exec redis-server /etc/redis/redis.conf
