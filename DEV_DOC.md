# Developer Documentation

This document explains how to set up the Inception stack from scratch, how to build and manage it, and where the persistent data lives.

## 1. Environment setup

### Prerequisites

Install these tools:
- Docker Engine
- Docker Compose plugin or Docker Compose support in Docker
- Make
- A shell with sudo access for creating host directories if required

### Repository layout

Important files and folders:
- `srcs/docker-compose.yml` — main Compose configuration
- `srcs/.env.example` — sample environment variables
- `srcs/requirements/` — Docker build contexts for each service
- `secrets/` — plain-text secret files referenced by Compose

### Create and configure `srcs/.env`

Copy the example file and update it for your host:

```bash
cp srcs/.env.example srcs/.env
```

At a minimum, set these values:
- `DOMAIN_NAME` — domain or host name for Nginx
- `WEB_PORT` — external HTTPS port for the website
- `DB_NAME`, `DB_USER`, `DB_PORT` — MariaDB settings
- `WP_PORT`, `WP_TITLE`, `WP_ADMIN_USER`, `WP_ADMIN_EMAIL` — WordPress values
- `WP_USER`, `WP_USER_EMAIL` — WordPress user values
- `REDIS_HOST`, `REDIS_PORT` — Redis connection values
- `FTP_USER`, `FTP_PORT`, `FTP_PASV_MIN_PORT`, `FTP_PASV_MAX_PORT` — FTP settings
- `STATIC_PORT` — static service port
- `ADMINER_PORT` — Adminer container port
- `PORTAINER_USER`, `PORTAINER_PORT` — Portainer configuration
- `VOLUME_MARIADB`, `VOLUME_WORDPRESS`, `VOLUME_REDIS`, `VOLUME_PORTAINER` — host directories used by bind-mounted volumes

### Secrets

Create the secret files under the project root `secrets/` folder. Each file must contain only the secret value.

Required secret files:

- `secrets/db_password.txt`
- `secrets/db_root_password.txt`
- `secrets/wp_password.txt`
- `secrets/wp_admin_password.txt`
- `secrets/ftp_password.txt`
- `secrets/portainer_password.txt`

The Compose configuration loads these files as Docker secrets. If any secret file is missing or empty, service startup may fail.

### Optional: permissions and file ownership

For security, ensure secret files are readable only by the user running Docker:

```bash
chmod 600 secrets/*.txt
```

## 2. Build and launch the project

The Makefile automates directory creation and Compose commands.

### Start the stack

```bash
make
```

This runs the `all` target, which depends on `volumes` and then starts the stack with `docker compose -f srcs/docker-compose.yml up -d`.

### Stop the stack

```bash
make down
```

### Remove containers and volumes

```bash
make clean
```

### Remove images and generated directories

```bash
make fclean
```

### Rebuild from scratch

```bash
make re
```

This removes all containers, volumes, and images and then rebuilds the stack.

## 3. Managing containers and volumes

### Common Docker Compose commands

List running services:

```bash
docker compose -f srcs/docker-compose.yml ps
```

Follow logs:

```bash
docker compose -f srcs/docker-compose.yml logs -f
```

View logs for one service:

```bash
docker compose -f srcs/docker-compose.yml logs -f nginx
```

Restart a service:

```bash
docker compose -f srcs/docker-compose.yml restart <service_name>
```

Execute a shell inside a service container:

```bash
docker compose -f srcs/docker-compose.yml exec <service_name> bash
```

### Volume inspection commands

List local Docker volumes:

```bash
docker volume ls
```

Inspect a named volume:

```bash
docker volume inspect srcs_mariadb_data
```

### Makefile volume creation

The Makefile target `volumes` creates the host directories referenced by `VOLUME_MARIADB`, `VOLUME_WORDPRESS`, `VOLUME_REDIS`, and `VOLUME_PORTAINER`.

If using the default example file, these directories will be created under the host user’s home directory.

## 4. Project data storage and persistence

### Persistent storage locations

The stack uses bind-mounted host directories for data persistence.

Host directory variables in `srcs/.env`:
- `VOLUME_MARIADB` — MySQL data storage
- `VOLUME_WORDPRESS` — WordPress files and uploads
- `VOLUME_REDIS` — Redis persistence
- `VOLUME_PORTAINER` — Portainer data storage

Because these are bind mounts, the data persists even when containers are recreated.

### Docker volumes mapped in Compose

In `srcs/docker-compose.yml`, the Compose volumes are configured with `driver_opts`:
- `wordpress_data` → `${VOLUME_WORDPRESS}`
- `mariadb_data` → `${VOLUME_MARIADB}`
- `redis_data` → `${VOLUME_REDIS}`
- `portainer_data` → `${VOLUME_PORTAINER}`

### Container names and network

The configured container names are:
- `mariadb_container`
- `wordpress_container`
- `nginx_container`
- `redis_container`
- `ftp_container`
- `adminer_container`
- `portainer_container`
- `static_container`

All services are attached to the `inception_network` bridge network.

## 5. Service endpoints used by developers

Through Nginx, the main service endpoints are:
- WordPress: `https://<DOMAIN_NAME>` or `https://<host>:<WEB_PORT>`
- WordPress admin: `https://<DOMAIN_NAME>/wp-admin`
- Adminer: `https://<DOMAIN_NAME>/adminer/`
- Portainer: `https://<DOMAIN_NAME>/portainer/`
- Static page: `https://<DOMAIN_NAME>/static/`

FTP access is direct on the configured `FTP_PORT` and passive port range.

## 6. Troubleshooting

If the stack does not start:
- Verify `srcs/.env` exists and contains valid values
- Verify all required `secrets/*.txt` files exist and contain the correct passwords
- Check `docker compose -f srcs/docker-compose.yml logs nginx`
- Check `docker compose -f srcs/docker-compose.yml logs wordpress`
- Confirm host directories in `VOLUME_*` are writable by Docker

If Nginx routes are failing, inspect `srcs/requirements/nginx/conf/nginx.conf` and confirm `DOMAIN_NAME`, `WEB_PORT`, and proxy locations match your configuration.
