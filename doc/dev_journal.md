# Development diary
This file is used to document my learning process through this project, I intend to write all the decisions and learning;

## [2026-06-17] - Structuring the project

I started by structuring the project, creating the necessary folders and files
I asked help for Claude to plan a roadmap of what should I do to develop the project,
as it has many services to implement.

## [2026-06-19] - Studying Docker
So Docker is a platform that allows to separate the infrastructure from the application itself;
It came to solve the problem of "It works on my machine" through containers that is 
an isolated environment on which you application is running.
It also facilitates deployment workflow and testing environment;

Images are a read-only template that has instructions to generate an container.
The steps are described in a file called Dockerfile; Each instructions is built in layers

Once created, an image cannot be altered, you'll need to change the Dockerfile to create a new image.
As the images are built in layers, if one layer is changed the image will be rebuilded from that layer.

Docker uses an client-server architecture where the docker client communicate with the
docker daemon via REST API, and this one manages the images, containers, networks, volumes and etc...

You can reuse images from another people and add additional layers to it; The images can be fetched
using registries, like Dockerhub.

### Namespaces and cgroups
Namespaces is a way that linux has to provide isolation to a process, limiting the system resources
without the process being aware of theses limitations.

cgroups is a feature from linux that allows to limit the usage of memory of a process;
It works like a "dog-collar" of the process, everytime that the process try to use 
more memory than it was defined, cgroups pulls that "collar".

### OCI Format
It's a pattern that defines how images should be packeged, distributed and distributed

Example of Dockerfile in OCI Format
`
# 1. Definição da imagem base
FROM alpine:3.20

# 2. Metadados obrigatórios e recomendados pelo padrão OCI
LABEL org.opencontainers.image.title="Inception - MariaDB" \
      org.opencontainers.image.description="Banco de dados customizado para o projeto Inception" \
      org.opencontainers.image.authors="thaperei@student.42sp.org.br" \
      org.opencontainers.image.source="https://github.com"

# 3. Configuração do ambiente de execução
WORKDIR /app

# 4. Instalação de dependências e cópia de arquivos
RUN apk add --no-cache curl
COPY . .

# 5. Definição do ponto de entrada do contêiner
ENTRYPOINT ["./minha-aplicacao"]
`
### Dockerfile

A document with a set of instructions to create a container image.

#### Common Instructions
- FROM <image>: Define the image base in which new layers will be added;
- WORKDIR <path>: Define a working directory of the image where files will be copied
and commands will be executed;
- COPY <host-path> <image-path>: Copies the files from to host to the image working directory;
- RUN <commands>: Run the specified command;
- ENV <name> <value> Define environment variables;
- EXPOSE <port>: Define which port the image would like to expose to the host
- CMD ["<command>", "<arg1>"]: This is the command that will be executed on the container
- ENTRYPOINT [<executable>, <params>]: Define an executable that will be run in the container

### Docker Best Practices
- Multistage build
- Choose an appropriated image
- Exclude unnecessary files with .dockerignore
- Decouple application: Each container should have one concern
- Order multi-line args

### Docker Compose
It's used to manage multiple containers, facilitates communication between them and
storage persistance;

- service: Define an abstract resource within an application;
- network: Establish connection between containers inside services
- volume: Allow the data persistance inside service

### PID 1
Represents the first process to be initialized at boot, it start and manages others
processes. By default, PID 1 doesn't receive signals like SIGINT and SIGTERM;
To avoid that, you should use tini to kill child processes;

## Wordpress
It's a content management system (CMS) that can be used to manage and create websites without knowing programming.

There two versions of the platform:

- It can be installed in a server and managed;
- It can be used as comercial service that hosts the website for you

### PHP - FPM (FastCGI Process Management)
It's a PHP implementation focused on deliver high-traffic sites with efficiency and isolation.

It runs separate processes and create more workers depending on the traffic

## NGINX (Engine X)
It's a webserver, reverse proxy, load balancer, content cache, TCP/UDP proxy server, mail proxy server.

It's known by it's high concurrency, low memory usage and performance

NGINX has a main process and several workers processes. The main process read and evaluate 
the configuration and manage the workers. The workers processes do the actual processing of requests.

NGINX works on an event-based model and uses SO mechanisms to distribute requests between workers.

### Generate SSL/TLS Certification
It's a encrypted certification to guarantee a safe and realiable connection 
for sending sensitive data between application.

In the case, I am going to use OpenSSL which is a toolkit of encryptation.
There are some flags that we use to generate it: 
`-x509`: it define the type of certificate that will be generated;
`-newkey rsa:4096`: it create a new private key that will use a rsa encrytion and 4096 bits;
`-keyout`: it define the output of the private key;
`-out`: it define the output of the certificate;
`-sha256`: it define that the algorithm of encryption is sha256;
`-days`: it define the time of expiration of the certificate;
`-subj`: it define additional informations to the certificate like the country, state and etcetera

__* For safety reasons you should use chmod to restrict the access of private key to the owner, and allow read-only permission for the certificate to other groups *

### Configuration Context

```bash
main                    # Define worker processes, linux user, PID, log file location
├── events              # Assign the number of connections for each worker
├── http                # Determine how http/https connections are handled
├   ├── server          # Process a http request
├   ├     └── location  # Defines how to process a http request based on the uri specified
├   └── upstream        # Defines a group of backend applications used for load balancing
└── streams             # Defines how to handle with layer 3 and 4 (TCP/UDP)
    ├── server
    ├    └── location
    └── upstream
```
#### location
It can be accessed by a prefix string or regex(~ for case-insensite or ~* for case-sensitive).
It looks for the longest matching string and remember it, then checks for the regex.
If no regex match is found, it uses the previous string stored, otherwise,
it uses the corresponding configuration.

#### server_name
It defines the name of the virtual server.
The first name is the primary server name

## Redis
Redis is single-threaded, when it needs to store data on disk, it forks a process.
Kernel prevents redis to store data on disk to allow permition enter the command:
`sudo sysctl vm.overcommit_memory=1` in the VM host machine

## FTP
FTP (file transfer protocol) is a protocol used to transfer files between hosts
in a network. It works in a client/server architecture, where there are two ports
that is used one for commands (21) and other for transfer files (range of ports).

