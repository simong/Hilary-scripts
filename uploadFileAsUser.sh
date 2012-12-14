#!/bin/bash

if [ "$1" = "--usage" ] ; then
    echo "This script will upload a file as a user."
    echo "--------------------------------------------------------"
    echo "./uploadFileAsUser.sh <tenant host> <username> <password:testtest>"
    echo "--------------------------------------------------------"
    echo "Example:"
    echo ""
    echo "./uploadFileAsUser.sh cam.oae.com simong testtest"
    echo "--------------------------------------------------------"
    exit 0
fi

source ./shared.sh


TENANT_HOST=$1
USERNAME=$2
PASSWORD=${3-"testtest"}

USER_COOKIE=$(curl -s --cookie-jar - -d"username=$2" -d"password=$3" http://${TENANT_HOST}/api/auth/login | grep connect.sid | cut -f 7)
if [ -z "${USER_COOKIE}" ] && [ "${USER_COOKIE+xxx}" = "xxx" ] ; then 
    echo $'\e[31m' "Could not log in as ${username}."
    exit 1;
fi


curl -s --cookie connect.sid=${USER_COOKIE} -F"file=@sakaiger.png" -F"contentType=file" -F"visibility=public" -F"name=test file" -F"description=some blabla" http://${TENANT_HOST}/api/content/create | python -m json.tool

