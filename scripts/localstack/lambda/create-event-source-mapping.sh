#!/bin/bash
# **************************
# Localstack Lambda Create Event Source Mapping Tool
# Version: 1.0.0
# **************************
if [ -z "$1" ]; then
  echo 'Function name must be informed'
  exit 1
else
  if [ -z "$2" ]; then
    echo 'Queue name must be informed'
    exit 1
  else
    if [ $RUNNING_IN_CONTAINER ]; then
      HOST=localstack
    else
      HOST=0.0.0.0
    fi
    REGION=us-east-1
    echo "aws --endpoint-url=http://$HOST:4566 lambda create-event-source-mapping \
    --function-name arn:aws:lambda:$REGION:000000000000:function:$1 \
    --event-source-arn arn:aws:sqs:$REGION:000000000000:$2"

    aws --endpoint-url=http://$HOST:4566 lambda create-event-source-mapping \
    --function-name arn:aws:lambda:$REGION:000000000000:function:$1 \
    --event-source-arn arn:aws:sqs:$REGION:000000000000:$2

    #--event-source-arn arn:aws:sqs:elasticmq:000000000000:$2
  fi
fi
