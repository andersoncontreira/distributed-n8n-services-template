# distributed-n8n-services-template
Project with a robust configuration of the service N8N for high volume of data.
The focus of this project is to help the community to easily configure this tool to meet scenarios of high process concurrency.
This project can process over than 30k events in less than 5 minutes.

## Service Architecture
Diagrams of the project architecture and others.

More details [here](#).

### Cloud Architecture
Example of the architecture that runs on AWS Cloud.

[//]: # (![Service-Arch]&#40;docs/ecs-service-arch.png&#41;)

### Docker Architecture
Example of the architecture that runs with docker.

[//]: # (![Docker-Service-Arch]&#40;docs/ecs-docker-service-arch.png&#41;)

## Routes of the service

Lista od routes:
```
GET / - Root
GET /workflows - Main route of the project
GET /healtz - Health Check
```

# Prerequisites
- docker
- docker-compose
- node
- n8n

## Features
- N8N
- N8N Concurrency support
- Projects Guidelines (Best practices)
- Docker Management (Docker-Compose)
- Localstack
- MySQL
- Redis
- CodeQuality (Sonar)
- Database Migrations

### Creating the Docker network
Execute the follow command:
```bash
./scripts/docker/create-network.sh
```

### Running locally
To create `venv` and install the modules, run:
```bash
yarn add
```
### Executing by Docker
To build execute the follow command:
```bash
./scripts/runenv.sh --build
```

Execute the follow command:
```bash
./scripts/runenv.sh
```

### Recovering the environment in error cases
Execute the follow command:
```bash
./scripts/fixenv.sh
```

## Information about automation scripts
The following describes the use of automation scripts.
These kebab case scripts help the developer in general tasks.

### General scripts
Kebab case scripts to help the developer with general tasks.

### General scripts
Kebab case scripts to help the developer with general tasks.

| Script                      | Description                                                                          | Context           |
|-----------------------------|--------------------------------------------------------------------------------------|-------------------|
| fixenv.sh                   | In some cases where the network is deleted, you can correct the container references | Local install     |
| preenv.sh                   | Script to run pre-build commands                                                     | Local boot        |
| runenv.sh                   | Script to start the project locally                                                  | Local development |
| testenv.sh                  | Script to run the environment focusing on component tests                            | Local development |

### Docker scripts
Scripts that facilitate tasks for docker context;
### Localstack scripts
Scripts that help execute commands on Localstack resources such as S3, SQS, Lambda, etc.
## Samples
See the project samples in this folder [here](samples).

## License
See the license: [LICENSE.md](LICENSE.md).

## Contribution
* Anderson de Oliveira Contreira [andersoncontreira](https://github.com/andersoncontreira)

