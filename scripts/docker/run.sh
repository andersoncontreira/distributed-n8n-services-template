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
#DB_MYSQLDB_HOST=0.0.0.0
DB_MYSQLDB_PORT=3306
DB_MYSQLDB_USER=root
DB_MYSQLDB_PASSWORD=n8n_workflow

# local vars
NATIVE=$1
DOCKER_IMAGE=$CONTAINER_NAME_0
NATIVE_N8N_IMAGE=n8nio/n8n

if [ -z "$NATIVE" ]; then
  echo "Running built n8n image: $DOCKER_IMAGE"
else
  echo "Running native n8n image: $NATIVE_N8N_IMAGE"
  DOCKER_IMAGE=$NATIVE_N8N_IMAGE
fi

#echo $DB_TYPE
#echo $DB_MYSQLDB_HOST
#echo $NETWORK_NAME
#echo $DB_MYSQLDB_USER
#echo $DB_MYSQLDB_PASSWORD

docker run \
  --network $NETWORK_NAME \
  -it --rm \
  --name $CONTAINER_NAME_0 \
  -p $APP_PORT:$APP_PORT \
  -e DB_TYPE=$DB_TYPE \
  -e DB_MYSQLDB_DATABASE=$DB_MYSQLDB_DATABASE \
  -e DB_MYSQLDB_HOST=$DB_MYSQLDB_HOST \
  -e DB_MYSQLDB_PORT=$DB_MYSQLDB_PORT \
  -e DB_MYSQLDB_USER=$DB_MYSQLDB_USER \
  -e DB_MYSQLDB_PASSWORD=$DB_MYSQLDB_PASSWORD \
  -v ~/.n8n:/home/node/.n8n \
  $DOCKER_IMAGE
#	\
#	n8n start