#!/bin/bash
# Name: lando-pull-alternative.sh
# Purpose:  Add lando setup to existing project
# Operation;  ./lando-pull-alternative.sh
# Usage:  Copy this file to the repo of interest.   Root level for git repo.  Run script and answer questions!
# Assumes you have terminus and lando installed already locally.
# Run ./lando-pull-alternate.sh -h for usage
# 
# NOTES:  You may need to change the file permission to executable first.   chmod +x lando-pull-alternative.sh
#

# Current Date string for branch strategies
DATE_NOW=`date '+%Y-%m-%d-%H-%M-%S'`

print_usage() {
  printf "\nNOTICE: You can select the following options to change \n";
  printf " site name (pantheon name: ie, fenzi-dog-sports)                      -n fenzi-dog-sports \n";
  printf " site env  (pantheon env:  ie, dev) : default 'dev'                   -z dev \n";
  printf " site elements to backup 'all|code|files|database|db' : default 'db'  -e db \n";
  printf " time to keep backup on pantheon 'days' : default '30'                -d 30\n";
  printf " generate latest backup 'yes|no' (note: takes time) : default 'no'    -b no\n";
  printf "\n EXAMPLE:       ./lando-pull-alternative.sh -n fenzi-dog-sports -z dev -d 30 -e db -b no\n";
  printf " USE DEFAULTS:  ./lando-pull-alternative.sh -n fenzi-dog-sports \n\n";
}

# default environment
SITE_NAME='';
GEN_BACKUP='no';
SITE_ENV='dev';
ELEMENTS='db';
DAYS='30';

### Get user inputs
while getopts ":b:n:z:e:d:" flag
do
    case "${flag}" in
        b) GEN_BACKUP=${OPTARG} ;;
        n) SITE_NAME=${OPTARG} ;;
        z) SITE_ENV=${OPTARG} ;;
        e) ELEMENTS=${OPTARG} ;;
        d) DAYS=${OPTARG} ;;
        *) print_usage
       exit 1 ;;
    esac
done

### SCRIPT BELOW ####
if [ -z ${SITE_NAME} ]
then
  echo "Please set the site name (-n) first  ...";
  echo "-- ${SITE_NAME} --";
  print_usage;
  echo "END";
  exit 1;
else
  printf "\n using repo location ${SITE_NAME}\n";
  printf "\n running command::: \n";
  printf "./lando-pull-alternative.sh -n ${SITE_NAME} -z ${SITE_ENV} -e ${ELEMENTS} -d ${DAYS} -b ${GEN_BACKUP} \n";
fi

## Clean up backups
printf "\n checking for any backups to delete first from previous runs...\n"
rm  "${DEVELOPMENT_CONFIG_REPO}/backup.url.tmp";
rm  "${DEVELOPMENT_CONFIG_REPO}/tmp.sql.gz";

# Local ENV variables
DEVELOPMENT_CONFIG_REPO=${PWD};

## Main
if [[ ${GEN_BACKUP} == "yes" ]]
then
  printf "\n...Generating backup from pantheon... hang on... maybe get a cup of coffee?\n\n"
  terminus backup:create ${SITE_NAME}.${SITE_ENV} --element=${ELEMENTS}  --keep-for=${DAYS}
fi
printf "\n...Pulling latest backup from pantheon...\n\n"
terminus backup:get ${SITE_NAME}.${SITE_ENV} --element=${ELEMENTS} > ${DEVELOPMENT_CONFIG_REPO}/backup.url.tmp
curl `cat ${DEVELOPMENT_CONFIG_REPO}/backup.url.tmp` --output tmp.sql.gz
lando db-import tmp.sql.gz

## Clean up backups
rm  "${DEVELOPMENT_CONFIG_REPO}/backup.url.tmp";
rm  "${DEVELOPMENT_CONFIG_REPO}/tmp.sql.gz";

## Message
