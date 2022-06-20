#!/bin/bash
if test -f .projectrc; then
  source .projectrc
elif test -f ./scripts/.projectrc; then
  source ./scripts/.projectrc
fi

export TEST_ENV=1
export DB_MYSQLDB_HOST=$(ifconfig docker0| grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1')
docker-compose up $1 $2 $3