#!/bin/sh

set -e

PORTAINER_PASSWORD=$(cat /run/secrets/portainer_password)

/usr/local/bin/portainer \
    -H unix:///var/run/docker.sock \
    --bind :${PORTAINER_PORT} &
PORTAINER_PID=$!

echo "Waiting for Portainer to start..."
until wget -qO- http://localhost:${PORTAINER_PORT}/api/system/status > /dev/null 2>&1; do
    sleep 1
done

CREDENTIAL_PAYLOAD=$(jq -n --arg user "$PORTAINER_USER" --arg pass "$PORTAINER_PASSWORD" \
	'{Username: $user, Password: $pass}')

wget -qO- \
    --post-data "$CREDENTIAL_PAYLOAD" \
    --header "Content-Type: application/json" \
    http://localhost:${PORTAINER_PORT}/api/users/admin/init > /dev/null 2>&1 && \
    echo "Portainer admin password set." || \
    echo "Portainer admin already initialized, skipping."

wait $PORTAINER_PID
