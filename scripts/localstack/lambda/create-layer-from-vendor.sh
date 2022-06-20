#!/bin/bash
# **************************
# Localstack Lambda Create Layer From Vendor Tool
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

#  if [ ! -z "$3" ]; then
#    FUNCTION_PATH=$1
#    FUNCTION_NAME=$2
#    HANDLER=$3
#  fi

  if [ -z "$LAYER_NAME" ]; then
    LAYER_NAME="$FUNCTION_PATH-layer"
  fi
  if [ -z "$LAYER_DESCRIPTION" ]; then
    LAYER_DESCRIPTION="$FUNCTION_PATH-layer"
  fi


  echo "Function name: $FUNCTION_NAME"
  echo "Function path: $FUNCTION_PATH"
  echo "Layer name: $LAYER_NAME"
  echo "Layer description: $LAYER_DESCRIPTION"


  # zip only code
  cd ./$FUNCTION_PATH
  python3 -m pip install -r requirements-vendor.txt -t ./layer
  zip ../layer.zip -r ./layer
  rm -Rf ./layer
  cd ../

  echo "aws --endpoint-url=http://$HOST:4566 lambda publish-layer-version --layer-name $LAYER_NAME \
   --description $LAYER_DESCRIPTION --zip-file fileb://layer.zip --compatible-runtimes \"python3.6\" \"python3.8\""

  aws --endpoint-url=http://$HOST:4566 lambda publish-layer-version --layer-name $LAYER_NAME \
   --description $LAYER_DESCRIPTION --zip-file fileb://layer.zip --compatible-runtimes "python3.6" "python3.8"

  echo "aws --endpoint-url=http://$HOST:4566 lambda update-function-configuration \
   --layers arn:aws:lambda:us-east-1:000000000000:layer:$LAYER_NAME:1 --function-name $FUNCTION_NAME"

   aws --endpoint-url=http://$HOST:4566 lambda update-function-configuration \
   --layers arn:aws:lambda:us-east-1:000000000000:layer:$LAYER_NAME:1 --function-name $FUNCTION_NAME

fi
