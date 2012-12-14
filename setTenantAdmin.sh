#!/bin/bash

if [ "$1" = "--usage" ] ; then
    echo "This script will make a user tenant admin."
    echo "The tenant host and user id are required."
    echo "--------------------------------------------------------"
    echo "./setTenantAdmin.sh <tenant host> <user id>"
    echo "--------------------------------------------------------"
    echo "Example:"
    echo ""
    echo "./setTenantAdmin.sh cam.oae.com u:cam:Fa5e-c2b"
    echo "--------------------------------------------------------"
    exit 0
fi

if [ $# -lt 2 ] ; then
    echo "You need to specify the tenant hostname and user id."
    exit 1
fi

source ./shared.sh

TENANT_HOST=$1
USER_ID=$2


STATUS=$(curl --silent --write-out %{http_code} --output /dev/null --cookie connect.sid=${ADMIN_COOKIE}  -d"admin=true" -d"id=${USER_ID}" http://${TENANT_HOST}/api/user/${USER_ID}/admin);
output $STATUS 200 "Made ${USER_ID} tenant admin."

