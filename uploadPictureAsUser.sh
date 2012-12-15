#!/bin/bash

if [ "$1" = "--usage" ] ; then
    echo "This script will upload a picture for a user and crop it."
    echo "--------------------------------------------------------"
    echo "./uploadPictureAsUser.sh <tenant host> <username> <password:testtest> <file:sakaiger.png> <x:0> <y:0> <width:100>"
    echo "--------------------------------------------------------"
    echo "Example:"
    echo ""
    echo "./uploadPictureAsUser.sh cam.oae.com simong"
    echo "./uploadPictureAsUser.sh cam.oae.com simong testtest sakaiger.png 10 10 50"
    echo "--------------------------------------------------------"
    exit 0
fi

source ./shared.sh


if [ $# -lt 2 ] ; then
    echo "You need to specify the tenant host and username."
    exit 1
fi

TENANT_HOST=$1
USERNAME=$2
PASSWORD=${3-"testtest"}
FILE=${4-"sakaiger.png"}
X=${5-"0"}
Y=${6-"0"}
WIDTH=${7-"100"}

# Log in
USER_COOKIE=$(curl -s --cookie-jar - -d"username=${USERNAME}" -d"password=${PASSWORD}" http://${TENANT_HOST}/api/auth/login | grep connect.sid | cut -f 7)
if [ -z "${USER_COOKIE}" ] && [ "${USER_COOKIE+xxx}" = "xxx" ] ; then 
    echo $'\e[31m' "Could not log in as ${username}."
    exit 1;
fi

# Get my ID.
USER_ID=$(curl --silent --cookie connect.sid=${USER_COOKIE} http://${TENANT_HOST}/api/me | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["userId"]')
output 200 200 "Uploading picture for ${USER_ID}"

# Upload the picture
STATUS=$(curl --silent --write-out %{http_code} --output /dev/null --cookie connect.sid=${USER_COOKIE} -F"file=@${FILE};type=image/png" http://${TENANT_HOST}/api/user/${USER_ID}/picture)
output $STATUS 200 "Uploaded the picture."

# Crop it
STATUS=$(curl --silent --write-out %{http_code} --output /dev/null  --cookie connect.sid=${USER_COOKIE} -d"principalId=${USER_ID}" -d"x=${X}" -d"y=${Y}" -d"width=${WIDTH}" http://${TENANT_HOST}/api/crop)
output $STATUS 200 "Cropped it."
