#!/bin/bash

if [ "$1" = "--usage" ] ; then
    echo "All parameters are optional. The default options will "
    echo "create a cambridge tenant as in the example."
    echo "--------------------------------------------------------"
    echo "./createTenant.sh <alias:cam> <tenant name:Cambridge> <hostname:cam.oae.com>"
    echo "--------------------------------------------------------"
    echo "Example:"
    echo ""
    echo "./createTenant.sh cam Cambridge cam.oae.com"
    echo "--------------------------------------------------------"
    exit 0
fi

# Load shared functionality
source ./shared.sh;

TENANT_ALIAS=${1-cam};
TENANT_NAME=${2-Cambridge}
TENANT_HOST=${3-cam.oae.com}

# Create a tenant.
STATUS=$(curl --silent --output /dev/null --write-out %{http_code} --cookie connect.sid=${ADMIN_COOKIE} -d"alias=${TENANT_ALIAS}" -d"name=${TENANT_NAME}" -d"host=${TENANT_HOST}" --header "Host: ${GLOBAL_HOST}" --header "Referer: /api" http://${GLOBAL_HOST}/api/tenant/create)
output $STATUS 200 "Created a tenant"