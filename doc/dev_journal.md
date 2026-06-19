# Development diary
This file is used to document my learning process through this project, I intend to write all the decisions and learning;

## [2026-06-17] - Structuring the project

I started by structuring the project, creating the necessary folders and files
I asked help for Claude to plan a roadmap of what should I do to develop the project,
as it has many services to implement.

## [2026-06-19] - Studying Docker
So Docker is a plataform that allows to separate the infrastructure from the application itself;
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
