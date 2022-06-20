#!/bin/bash
# **************************
# Localstack S3 List Files Tool
# Version: 1.0.0
# **************************
if [ $RUNNING_IN_CONTAINER ]; then
  HOST=localstack
else
  HOST=0.0.0.0
fi

BUCKET=$1
if [ -z "$BUCKET" ]
then
  # todo criar regras
#  if test -f ${current_parent_folder}.projectrc; then
#    source ${current_parent_folder}.projectrc
#  fi
  if [ -z "$APP_BUCKET" ]
  then
    BUCKET="test-bucket"
  else
    BUCKET=$APP_BUCKET
  fi
fi
echo "aws --endpoint-url=http://$HOST:4566 s3 ls s3://$BUCKET"
aws --endpoint-url=http://$HOST:4566 s3 ls s3://$BUCKET