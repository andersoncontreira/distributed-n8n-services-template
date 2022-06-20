#!/bin/bash
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
#echo "xxxxx current_file_path_basename $current_file_path_basename"

if [ -z "$current_file_path_basename" ] || [ $current_file_path = "./" ]; then
#  echo 'aq'
  current_parent_folder="../"
else
#  echo 'naq'
  current_file_path_basename=$current_file_path_basename/
  current_parent_folder="${current_file_path/$current_file_path_basename/''}"
fi

#if [ "$ENVIRONMENT_NAME" == "development" ]; then
#  echo 'development env, running the users creation'
#  mysql -h localhost -u user root -pn8n_workflow < samples/query/create.user.sql
#fi
