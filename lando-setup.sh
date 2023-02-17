#!/bin/bash
# Name: lando-setup.sh
# Purpose:  Add lando setup to existing project
# Operation;  ./lando-setup.sh
# Usage:  Clone repo locally.   Change the values in the .env file to point to your expected location for the files to be generated
# 
# NOTES:  You may need to change the file permission to executable first.   chmod +x lando-setup.sh
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
LANDO_SOURCE_DIR="lando";

### Verifying expected source Directory exists ####
if [ -z ${LANDO_SOURCE_DIR} ]
then
  echo "EXITING:  Can't open dir:  Please check location for ${LANDO_SOURCE_DIR}..."
  exit 1;
else
  echo "using source data location: ${LANDO_SOURCE_DIR}"
fi

### Generic first level testing SCRIPT BELOW ####
if [ -z ${WRITE_PATH} ]
then
  printf "\n TROUBLE::  Can't open dir:  Please check location for ${WRITE_PATH}..."
  exit 1;
else
  echo "write to data location: ${WRITE_PATH}"
fi

## Copy files
cp ${DEVELOPMENT_CONFIG_REPO}/.lando.yml ${WRITE_PATH}/.lando.yml;
cp -r ${DEVELOPMENT_CONFIG_REPO}/lando ${WRITE_PATH}/lando;

for fn in `cat .env.lando`; do
    arrIN=(${fn//=/ })
    VAR=${arrIN[0]};
    SUB=${arrIN[1]}
    ## Swap template values
    sed -i.bu "s@"\"\$$VAR\""@"$SUB"@" ${WRITE_PATH}/.lando.yml
done

## Clean up backups
rm  "${WRITE_PATH}/.lando.yml.bu";

## Message
printf "\n----- Result Files -----\n";
ls -lrt ${WRITE_PATH}/.lando.yml;
ls -lrt ${WRITE_PATH}/lando;