#!/bin/bash
# **************************
# Localstack Lambda Create Layer Tool
# Version: 1.0.0
# **************************
# https://aws.amazon.com/premiumsupport/knowledge-center/lambda-layer-simulated-docker/
if [ -z "$1" ]; then
  echo 'Function path must be informed'
  exit 1
else
  if [ $RUNNING_IN_CONTAINER ]; then
    HOST=localstack
  else
    HOST=0.0.0.0
  fi
  FUNCTION_PATH=$1
  FUNCTION_NAME=$1
  LAYER_NAME=$2
  LAYER_DESCRIPTION=$3


  if [ -z "$LAYER_NAME" ]; then
    LAYER_NAME="$FUNCTION_PATH-layer"
  fi
  if [ -z "$LAYER_DESCRIPTION" ]; then
    LAYER_DESCRIPTION="$FUNCTION_PATH-layer"
  fi


  if test -f "$FUNCTION_PATH/requirements-layers.txt"; then
    input="$FUNCTION_PATH/requirements-layers.txt"
    while IFS= read -r arn
    do
      echo "current arn: $arn"
      echo "aws --endpoint-url=http://$HOST:4566 lambda update-function-configuration \
     --layers $arn --function-name $FUNCTION_NAME"

     aws --endpoint-url=http://$HOST:4566 lambda update-function-configuration \
     --layers $arn --function-name $FUNCTION_NAME
    done < "$input"
  fi
fi
