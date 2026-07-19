# User Documentation

This project runs a WordPress-based website inside Docker containers. It includes the website, database, cache, administration tools, and an FTP service.

## What services are provided by the stack?

The stack provides the following services:

- **WordPress**: the main website application
- **Nginx**: the HTTPS web server and reverse proxy for the site, Adminer, Portainer, and static page
- **MariaDB**: the database back end for WordPress
- **Redis**: a cache service for WordPress
- **FTP**: a file transfer service for website files
- **Adminer**: a web-based database administration panel, exposed under `/adminer/`
- **Portainer**: a Docker container management dashboard, exposed under `/portainer/`
- **Static page**: a bonus static site available under `/static/`

## Start and stop the project

### Prerequisites

- Docker installed and running
- Docker Compose plugin or Docker Compose available
- Make installed on the host machine
- A valid `srcs/.env` file with the required environment values
- Required secret files in the `secrets/` directory

### Start the stack

From the project root, run:

```bash
make
```

This target creates required host directories and starts all containers in detached mode.

### Stop the stack

To stop the containers without removing volumes:

```bash
make down
```

### Remove containers and volumes

To remove the containers and Docker volumes created by the stack:

```bash
make clean
```

### Full cleanup

To remove containers, volumes, and the generated Docker images:

```bash
make fclean
```

## Access the website and administration panel

The front-end website is served by the Nginx container.

If your configuration file uses `DOMAIN_NAME` and `WEB_PORT`, the website is available at:

```text
https://<DOMAIN_NAME>
```

If `WEB_PORT` is not 443 or you are testing locally, use:

```text
https://<host>:<WEB_PORT>
```

### WordPress admin panel

Open the WordPress dashboard at:

```text
https://<DOMAIN_NAME>/wp-admin
```

### Adminer database panel

Open Adminer at:

```text
https://<DOMAIN_NAME>/adminer/
```

### Portainer dashboard

Open Portainer at:

```text
https://<DOMAIN_NAME>/portainer/
```

### Static page

Open the static website at:

```text
https://<DOMAIN_NAME>/static/
```

### FTP access

FTP is exposed on the configured `FTP_PORT` and the passive port range defined by `FTP_PASV_MIN_PORT` and `FTP_PASV_MAX_PORT` in `srcs/.env`.

Connect with any FTP client to:

```text
<host>:<FTP_PORT>
```

## Locate and manage credentials

The stack loads credentials from plain text secret files under the project root `secrets/` directory.

Required credentials files:

- `secrets/db_password.txt`
- `secrets/db_root_password.txt`
- `secrets/wp_password.txt`
- `secrets/wp_admin_password.txt`
- `secrets/ftp_password.txt`
- `secrets/portainer_password.txt`

> The Compose configuration mounts these secret files into containers at runtime. Do not store sensitive secrets in a public repository.

If a file is missing or empty, the corresponding container may fail to start.

## Check that the services are running correctly

List running containers for this stack:

```bash
docker compose -f srcs/docker-compose.yml ps
```

Look for these containers:
- `mariadb_container`
- `wordpress_container`
- `nginx_container`
- `redis_container`
- `ftp_container`
- `adminer_container`
- `portainer_container`
- `static_container`

Inspect service logs for issues:

```bash
docker compose -f srcs/docker-compose.yml logs <service_name>
```

For example:

```bash
docker compose -f srcs/docker-compose.yml logs nginx
```

If the website loads correctly and the `/wp-admin` page is reachable, the stack is working.
