#!/bin/bash
if test -f .projectrc; then
  source .projectrc
elif test -f ./scripts/.projectrc; then
  source ./scripts/.projectrc
fi

# validation
if [ -z "$APP_NAME" ]; then
  echo '$APP_NAME not defined'
  exit 1
fi

# general
ENVIRONMENT_NAME=development
# container env vars
CONTAINER_NAME_0=$APP_NAME
CONTAINER_PORT_0=$APP_PORT
# database env vars
DB_TYPE=mysqldb
DB_MYSQLDB_DATABASE=n8n_workflow
DB_MYSQLDB_HOST=$(ifconfig docker0| grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')
DB_MYSQLDB_PORT=3306
DB_MYSQLDB_USER=root
DB_MYSQLDB_PASSWORD=n8n_workflow

docker build \
          --build-arg SERVICE_PORT=$CONTAINER_PORT_0 \
          --build-arg PROJECT_NAME=$APP_NAME \
          --build-arg ENVIRONMENT_NAME=$ENVIRONMENT_NAME \
          -t $CONTAINER_NAME_0 \
          -f docker/n8n/Dockerfile .