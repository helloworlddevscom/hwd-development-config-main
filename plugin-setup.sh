#!/bin/bash
# Name: plugin-setup.sh
# Purpose:  Add plugin and local webpack to existing project
# Operation;  ./plugin-setup.sh
# Usage:  Clone repo locally.   Change the values in the .env file to point to your expected location for the files to be generated
# 
# NOTES:  You may need to change the file permission to executable first.   chmod +x plugin-setup.sh
#

# Current Date string for branch strategies
DATE_NOW=`date '+%Y-%m-%d-%H-%M-%S'`

if [ -f .env.lando ]; then
   # Load Environment Variables
   export $(cat .env.lando | grep -v '#' | awk '/=/ {print $1}')
   printf "\nloaded variables from .env.lando\n\n"
else
  printf "\n TROUBLE::  unable to load .env.lando file.  Copy .env.example to get started\n\n"
fi

## All ENV listed in .env.lando are now available.
# Local ENV variables
DEVELOPMENT_CONFIG_REPO=${PWD};

### Generic first level testing SCRIPT BELOW ####
if [ -z ${WRITE_PATH} ]
then
  printf "\n TROUBLE::  Can't open dir:  Please check location for ${WRITE_PATH}..."
  exit 1;
else
  echo "write to data location: ${WRITE_PATH}"
fi

## Copy files
cp ${DEVELOPMENT_CONFIG_REPO}/.nvmrc ${WRITE_PATH}/.nvmrc;
cp ${DEVELOPMENT_CONFIG_REPO}/package.json ${WRITE_PATH}/package.json;
cp ${DEVELOPMENT_CONFIG_REPO}/webpack.common.js ${WRITE_PATH}/webpack.common.js;
cp ${DEVELOPMENT_CONFIG_REPO}/webpack.dev.js ${WRITE_PATH}/webpack.dev.js;
cp ${DEVELOPMENT_CONFIG_REPO}/webpack.prod.js ${WRITE_PATH}/webpack.prod.js;

for fn in `cat .env.lando`; do
    arrIN=(${fn//=/ })
    VAR=${arrIN[0]};
    SUB=${arrIN[1]}
    ## Swap template values
    sed -i.bu "s@"\"\$$VAR\""@"$SUB"@g" ${WRITE_PATH}/package.json
    sed -i.bu "s@"\"\$$VAR\""@"$SUB"@g" ${WRITE_PATH}/webpack.common.js
    sed -i.bu "s@"\"\$$VAR\""@"$SUB"@g" ${WRITE_PATH}/webpack.dev.js
    sed -i.bu "s@"\"\$$VAR\""@"$SUB"@g" ${WRITE_PATH}/webpack.prod.js
done

## Create Skeleton Files
cp -rf ${DEVELOPMENT_CONFIG_REPO}/.github ${WRITE_PATH}/;
cp -rf ${DEVELOPMENT_CONFIG_REPO}/src ${WRITE_PATH}/web/wp-content/plugins/${PLUGIN_NAME}/includes/src;


## Clean up backups
rm  "${WRITE_PATH}/package.json.bu";
rm  "${WRITE_PATH}/webpack.common.js.bu";
rm  "${WRITE_PATH}/webpack.dev.js.bu";
rm  "${WRITE_PATH}/webpack.prod.js.bu";

## Message
printf "\n----- Result Files -----\n";
ls -lrt ${WRITE_PATH}/webpack*;
ls -lrt ${WRITE_PATH}/package.json;