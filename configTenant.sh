#!/bin/bash

if [ "$1" = "--usage" ] ; then
    echo "This script will disable the reCaptcha settings."
    echo "Only the tenant host is required."
    echo "--------------------------------------------------------"
    echo "./configTenant.sh <tenant host> "
    echo "--------------------------------------------------------"
    echo "Example:"
    echo ""
    echo "./configTenant.sh cam.oae.com"
    echo "--------------------------------------------------------"
    exit 0
fi

if [ $# -eq 0 ] ; then
    echo "You need to specify the tenant hostname."
    exit 1
fi

source ./shared.sh

STORAGE="local"

STATUS=$(curl --silent --output /dev/null --write-out %{http_code} --cookie connect.sid=${ADMIN_COOKIE} \
-d"oae-content/default-content-copyright/defaultcopyright=nocopyright" \
-d"oae-content/visibility/files=loggedin" \
-d"oae-content/contentpermissions/defaultaccess=public" \
-d"oae-content/documentpermissions/defaultaccess=public" \
-d"oae-content/linkpermissions/defaultaccess=public" \
-d"oae-content/collectionpermissions/defaultaccess=public" \
-d"oae-content/default-content-privacy/defaultprivacy=everyone" \
-d"oae-content/storage/backend=local" \
-d"oae-content/storage/local-dir=/opt/sakai/oae/files" \
-d"oae-content/storage/amazons3-access-key=<your Amazon Access key>" \
-d"oae-content/storage/amazons3-secret-key=<your Amazon secret key>" \
-d"oae-content/storage/amazons3-region=us-east-1" \
-d"oae-content/storage/amazons3-bucket=oae-performance-files" http://${GLOBAL_HOST}/api/config);
output $STATUS 200 "Configured storage with the ${STORAGE} backend"


STATUS=$(curl --silent --output /dev/null --write-out %{http_code} --cookie connect.sid=${ADMIN_COOKIE} -d"oae-principals/recaptcha/enabled=false" http://${GLOBAL_HOST}/api/config)
output $STATUS 200 "Turned reCaptcha off"

