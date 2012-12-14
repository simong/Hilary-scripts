#!/bin/bash

if [ "$1" = "--usage" ] ; then
    echo "Only the tenant host and username are required."
    echo "The defaults can be found after the colon for each parameter."
    echo "--------------------------------------------------------------"
    echo "./createUser.sh <tenant host> <username> <password:testtest> <firstname:Test> <lastname:User> <displayName:Test User> <locale:en_GB> <timezone:Europe/London>"
    echo "--------------------------------------------------------------"
    echo "Example:"
    echo ""
    echo "./createUser.sh cam.oae.com simong testtest Simon Gaeremynck simong en_GB Europe/London"
    echo "./createUser.sh cam.oae.com simong"
    echo "--------------------------------------------------------------"
    exit 0
fi

if [ $# -lt 2 ] ; then
    echo "You need to specify the tenant host and username."
    exit 1
fi

# Load shared functionality
source ./shared.sh

TENANT_HOST=$1
USERNAME=$2
PASSWORD=${3-"testtest"}
FIRSTNAME=${4-"Test"}
LASTNAME=${5-"User"}
DISPLAYNAME=${6-"Test User"}
LOCALE=${7-"en_GB"}
TIMEZONE=${8-"Europe/London"}

# Create a user.
STATUS=$(curl --silent --output /dev/null --write-out %{http_code} -d"smallPicture=${USERNAME}" -d"firstName=${FIRSTNAME}" -d"lastName=${LASTNAME}" -d"displayName=${DISPLAYNAME}" -d"password=${PASSWORD}" -d"locale=${LOCALE}" -d"timezone=${TIMEZONE}" http://${TENANT_HOST}/api/user/create)
output $STATUS 201 "Created user ${USERNAME}"