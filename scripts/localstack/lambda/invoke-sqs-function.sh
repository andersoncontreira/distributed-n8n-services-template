#!/bin/bash
# **************************
# Localstack Lambda Invoke SQS Function Tool
# Version: 1.0.0
# **************************
if [ -z "$1" ]; then
  echo 'Function name must be informed'
  exit 1
else

  if [ $RUNNING_IN_CONTAINER ]; then
    HOST=localstack
  else
    HOST=0.0.0.0
  fi
  FUNCTION_PATH=$1
  FUNCTION_NAME=$1
  if test -d ./$FUNCTION_PATH; then
    PAYLOAD=./$FUNCTION_PATH/samples/localstack/sqs_sample.json
  else
    PAYLOAD=./samples/localstack/sqs_sample.json
  fi


  echo "Function name: $FUNCTION_NAME"
  echo "Function path: $FUNCTION_PATH"
  echo "Function ARN arn:aws:lambda:us-east-1:000000000000:$FUNCTION_NAME"

  echo "aws --endpoint-url=http://$HOST:4566 lambda invoke \
  --function-name arn:aws:lambda:us-east-1:000000000000:function:$FUNCTION_NAME \
  --invocation-type RequestResponse \
  --payload file://$PAYLOAD ./output/response.json \
  --log-type Tail --query 'LogResult' --output text |  base64 -d"

  if ! test -d ./output; then
    echo 'creating dir ./output'
    mkdir ./output
  fi

  aws --endpoint-url=http://$HOST:4566 lambda invoke \
  --function-name arn:aws:lambda:us-east-1:000000000000:function:$FUNCTION_NAME \
  --invocation-type RequestResponse \
  --payload file://$PAYLOAD ./output/response.json \
  --log-type Tail --query 'LogResult' --output text |  base64 -d

  echo "\nResponse"
  echo 'cat ./output/response.json'
  cat ./output/response.json

#  echo $PAYLOAD
#  cat $PAYLOAD
fi

