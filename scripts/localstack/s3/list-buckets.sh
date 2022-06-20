#!/bin/bash
# **************************
# Localstack S3 List Buckets Tool
# Version: 1.0.0
# **************************
if [ $RUNNING_IN_CONTAINER ]; then
  HOST=localstack
else
  HOST=0.0.0.0
fi
echo "aws --endpoint-url=http://$HOST:4566 s3 ls"
aws --endpoint-url=http://$HOST:4566 s3 ls