#!/bin/bash

if [ "$1" = "--usage" ] ; then
    echo "This script will list all the tenants."
    echo "--------------------------------------------------------"
    echo "./listTenants.sh"
    echo "--------------------------------------------------------"
    echo "Example:"
    echo ""
    echo "./listTenants.sh"
    echo "--------------------------------------------------------"
    exit 0
fi

source ./shared.sh


curl --cookie connect.sid=${ADMIN_COOKIE} http://${GLOBAL_HOST}/api/tenants | python -m json.tool

