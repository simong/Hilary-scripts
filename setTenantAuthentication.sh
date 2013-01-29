#!/bin/bash

if [ "$1" = "--usage" ] ; then
    echo "This script will enable or disable an authentication provider.."
    echo "--------------------------------------------------------"
    echo "./setTenantAuthentication.sh <tenant host> <authentication name> <true/false>"
    echo "--------------------------------------------------------"
    echo "Example:"
    echo "The following will enable the google authentication:"
    echo "./setTenantAuthentication.sh cam.oae.com google true"
    echo "--------------------------------------------------------"
    exit 0
fi

if [ $# -lt 3 ] ; then
    echo "You need to specify the tenant hostname."
    exit 1
fi

source ./shared.sh


TENANT_HOST=$1
AUTH_NAME=$2
ENABLED=$3

STATUS=$(curl --silent --output /dev/null --write-out %{http_code} --cookie connect.sid=${ADMIN_COOKIE} -d"oae-authentication/${AUTH_NAME}/enabled=${ENABLED}" http://${TENANT_HOST}/api/config)
output $STATUS 200 "Changed the authentication setting."

