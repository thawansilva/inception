*This project has been created as part of the 42 curriculum by thaperei.*

# Inception

## Description

Inception is a containerized web stack built for the 42 curriculum. The project uses Docker Compose to launch a WordPress website with a MariaDB back end, Redis cache, Nginx reverse proxy, FTP service, Adminer database panel, Portainer container manager, and a small static site.

The goal is to provide a working local web environment that demonstrates container orchestration, persistent storage, service proxies, and administration tooling.

## Project Description

This project uses Docker to containerize each service of the web stack and to make the application easier to deploy, isolate, and manage. The main services are built from Docker images defined in the `srcs/requirements/` directory and are orchestrated together through Docker Compose.

### Service Communication Flow

```
Internet (Port 443)
    ↓
NGINX (Reverse Proxy)
    ├─→ WordPress + PHP-FPM (Port 9000 internal)
    ├─→ Adminer (Port 8080 internal)
    ├─→ Static Site (Port 8081 internal)
    └─→ Portainer (Port 9000 internal)

WordPress dependencies:
    ├─→ MariaDB (Port 3306 internal)
    └─→ Redis (Port 6379 internal)

Additional Services:
    ├─→ FTP Server (Port 2121 external)
    └─→ Portainer (Port 9000 external mapped)
```

### Main design choices

- Docker is used to isolate each service and simplify deployment.
- Each component is packaged independently so that the project can be built and restarted consistently.
- Persistent storage is handled with host-mounted directories and Docker volumes to keep data available across container restarts.
- Sensitive values are stored in Docker secrets instead of being hardcoded into configuration files.

### Virtual Machines vs Docker

Virtual Machines (VMs) provide full operating systems and stronger isolation, but they are heavier and slower to start. Docker containers share the host kernel and are lighter, faster, and more efficient for running multiple services in a compact environment.

### Secrets vs Environment Variables

Environment variables are useful for non-sensitive configuration values such as ports, names, and paths. Secrets are intended for confidential information such as passwords and private credentials, and they are handled more securely by Docker.

### Docker Network vs Host Network

A Docker network allows containers to communicate with each other through an isolated internal network, which is ideal for a multi-service application. A host network shares the host's network stack and is less isolated, but it can be useful for specific cases where services need direct access to host networking.

### Docker Volumes vs Bind Mounts

Docker volumes are managed by Docker and are convenient for persistent container data. Bind mounts map a directory from the host filesystem into the container, which gives more direct control over where data is stored on the machine.

## Instructions

### Prerequisites

- Docker installed and running
- Docker Compose plugin or Docker Compose available
- Make installed on the host machine

### Setup

1. Copy the example environment file:
   ```bash
   cp srcs/.env.example srcs/.env
   ```
2. Edit `srcs/.env` to set the domain name, ports, database values, WordPress credentials, and local volume paths.
3. Create the required secret files in the `secrets/` directory. Each file should contain the secret value only.

### Execution

From the project root, start the stack with:
```bash
make
```

Stop the stack with:
```bash
make down
```

Remove containers and volumes:
```bash
make clean
```

Fully remove containers, volumes, and built images:
```bash
make fclean
```

## Resources

- Docker documentation: https://docs.docker.com
- Docker Compose documentation: https://docs.docker.com/compose/
- WordPress documentation: https://wordpress.org/support/article/installing-wordpress/
- MariaDB documentation: https://mariadb.com/kb/en/library/documentation/
- Nginx documentation: https://nginx.org/en/docs/
- Portainer repository: https://github.com/portainer/portainer
- Redis Documentation: https://redis.io/documentation

### AI usage

AI was used to find bugs, understand problems with services at startup or connections with other services, and explain concepts involved in each service.
AI was used to help create and organize the project documentation for `README.md`, `USER_DOC.md`, and `DEV_DOC.md`.