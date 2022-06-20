#!/bin/bash
# **************************
# Localstack Lambda Create Function From S3 Tool
# Version: 1.0.0
# **************************
# -----------------------------------------------------------------------------
# Current file variables
# -----------------------------------------------------------------------------
debug=false
parent_folder="../"
current_path=$(pwd)/
current_path_basename=$(basename $(pwd))
current_file_full_path=$0
# echo $current_filepath
current_file_name=$(basename -- "$0")
# echo $current_filename
if [ $current_file_full_path = $current_file_name ] || [ $current_file_full_path = "./$current_file_name" ]; then
  current_file_full_path="./${current_file_full_path}"
  current_file_path="./"
else
  current_file_path="${current_file_full_path/$current_file_name/''}"
fi


current_file_path_basename=$(basename -- "$current_file_path")

if [ -z "$current_file_path_basename" ] || [ $current_file_path = "./" ]; then
#  echo 'aq'
  current_parent_folder="../"
else
#  echo 'naq'
  current_file_path_basename=$current_file_path_basename/
  current_parent_folder="${current_file_path/$current_file_path_basename/''}"
fi

if [ debug ]; then
  echo '----------------------------------------'
  echo "$0 - Script variables"
  echo '----------------------------------------'
  echo "current_path: $current_path"
  echo "current_path_basename: $current_path_basename"
  echo "current_file_full_path: $current_file_full_path"
  echo "current_file_name: $current_file_name"
  echo "current_file_path: $current_file_path"
  echo "current_parent_folder: $current_parent_folder"
  echo '----------------------------------------'
fi

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
  HANDLER=$2
  REGION=us-east-1
  if [ -z "$2" ]; then
    HANDLER="app.index"
  fi

  if [ ! -z "$3" ]; then
    FUNCTION_PATH=$1
    FUNCTION_NAME=$2
    HANDLER=$3
  fi

  echo '----------------------------------------'
  echo "$0 - Checking lambda function path"
  echo '----------------------------------------'
  if test "${current_path_basename}" = "${FUNCTION_PATH}"; then
    echo 'current folder is the same of the function'
    FUNCTION_PATH=$current_path
  else
    echo 'current folder is not the same of the function'
    FUNCTION_PATH="${current_parent_folder/scripts\/localstack\//''}"
  fi

  read -p "Press enter to continue..."

  echo '----------------------------------------'
  echo "$0 - Checking previous installation"
  echo '----------------------------------------'
  # zip full code
  if test -f ${FUNCTION_PATH}lambda-full.zip; then
    echo 'Removing old zip file...'
    rm ${FUNCTION_PATH}lambda-full.zip
  else
    echo 'There is no previous installation'
  fi

  read -p "Press enter to continue..."

  echo '----------------------------------------'
  echo "$0 - Script Function variables"
  echo '----------------------------------------'
  echo "Function name: $FUNCTION_NAME"
  echo "Function path: $FUNCTION_PATH"
  echo "Function handler: $HANDLER"
  echo '----------------------------------------'

  echo '----------------------------------------'
  echo "$0 - Zipping lambda data from ${FUNCTION_PATH}"
  echo '----------------------------------------'
  LAST_PWD=$(pwd)
  cd ${FUNCTION_PATH}
  zip -q -r ./lambda-full.zip ./ -x '*.git*' -x "./zip.sh*" -x "./venv/*" -x "./.idea/*" -x "./lambda-full.zip"
  echo "zip file created in ${FUNCTION_PATH}lambda-full.zip"
  cd ${LAST_PWD}

  read -p "Press enter to continue..."

  echo '----------------------------------------'
  echo "$0 - Preparing bucket operations"
  echo '----------------------------------------'
  echo 'Try to list'
  echo "aws --endpoint-url=http://$HOST:4566 s3api list-objects --bucket test > /dev/null 2>&1"
  aws --endpoint-url=http://$HOST:4566 s3api list-objects --bucket test > /dev/null 2>&1

  if [ $? -ne 0 ]; then
    echo 'Create the bucket'
    echo "aws --endpoint-url=http://$HOST:4566 s3 mb s3://test"
    aws --endpoint-url=http://$HOST:4566 s3 mb s3://test
  fi

  echo '----------------------------------------'
  echo "$0 - Copy lambda zip file to S3"
  echo '----------------------------------------'
  echo "aws --endpoint-url=http://$HOST:4566 s3 cp ${FUNCTION_PATH}lambda-full.zip s3://test"
  aws --endpoint-url=http://$HOST:4566 s3 cp ${FUNCTION_PATH}lambda-full.zip s3://test

  read -p "Press enter to continue..."

  echo '----------------------------------------'
  echo "$0 - Check if the lambda function exits"
  echo '----------------------------------------'
  echo "aws --endpoint-url=http://$HOST:4566 lambda get-function --function-name $FUNCTION_NAME --region $REGION > /dev/null 2>&1"
  aws --endpoint-url=http://$HOST:4566 lambda get-function --function-name $FUNCTION_NAME --region $REGION > /dev/null 2>&1

  if [ $? -eq 0 ]; then
    echo 'Delete the last lambda'
    echo "aws --endpoint-url=http://$HOST:4566 lambda delete-function --function-name $FUNCTION_NAME --region $REGION"
    aws --endpoint-url=http://$HOST:4566 lambda delete-function --function-name $FUNCTION_NAME --region $REGION
  fi

  echo '----------------------------------------'
  echo "$0 - Creating the environment variables"
  echo '----------------------------------------'

  if test -d ${FUNCTION_PATH}.chalice; then
      ENVIRONMENT_VARIABLES=$(jq '.stages.dev.environment_variables' ${FUNCTION_PATH}.chalice/config.json -c)
    else
      ENVIRONMENT_VARIABLES=$(python3 ${FUNCTION_PATH}scripts/tools/python/env-to-json.py ${FUNCTION_PATH}env/development.env)
    fi

  echo "ENVIRONMENT_VARIABLES: ${ENVIRONMENT_VARIABLES}"
  #  echo "{\"Variables\": $ENVIRONMENT_VARIABLES }"
  #  echo {"Variables": $ENVIRONMENT_VARIABLES} > environment.json

  read -p "Press enter to continue..."

  echo '----------------------------------------'
  echo "$0 - Creating the lambda function"
  echo '----------------------------------------'
  echo "aws --endpoint-url=http://$HOST:4566 lambda create-function \
   --function-name arn:aws:lambda:$REGION:000000000000:function:$FUNCTION_NAME \
   --runtime python3.6 --handler $HANDLER --memory-size 128 \
   --code S3Bucket=test,S3Key=lambda-full.zip --role arn:aws:iam:awslocal \
   --environment \"{\"Variables\": $ENVIRONMENT_VARIABLES}\""

  aws --endpoint-url=http://$HOST:4566 lambda create-function \
   --function-name arn:aws:lambda:$REGION:000000000000:function:$FUNCTION_NAME \
   --runtime python3.6 --handler $HANDLER --memory-size 128 \
   --code S3Bucket=test,S3Key=lambda-full.zip --role arn:aws:iam:awslocal \
   --environment "{\"Variables\": $ENVIRONMENT_VARIABLES }"
   #--environment Variables="{ENVIRONMENT_NAME=development}"
   # --environment file://environment.json

fi