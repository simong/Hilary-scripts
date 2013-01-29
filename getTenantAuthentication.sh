#!/bin/bash

if [ "$1" = "--usage" ] ; then
    echo "This script will get the tenant authentication"
    echo "--------------------------------------------------------"
    echo "./getTenantAuthentication.sh <tenant host>"
    echo "--------------------------------------------------------"
    echo "Example:"
    echo "./getTenantAuthentication.sh cam.oae.com"
    echo "--------------------------------------------------------"
    exit 0
fi

if [ $# -lt 1 ] ; then
    echo "You need to specify the tenant hostname."
    exit 1
fi

source ./shared.sh


TENANT_HOST=$1

curl -s --cookie connect.sid=${ADMIN_COOKIE} http://${TENANT_HOST}/api/config | python -m json.tool