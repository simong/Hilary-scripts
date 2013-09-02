#!/bin/bash

# Load shared functionality
source ./shared.sh;

TENANT_ALIAS=${1-cam};
TENANT_NAME=${2-Cambridge}
TENANT_HOST=${3-cam.oae.com}

# Create a tenant.
STATUS=$(curl -k --silent --output /dev/null --write-out %{http_code} --cookie connect.sess=${ADMIN_COOKIE} -e "/" -d"alias=${TENANT_ALIAS}" -d"displayName=${TENANT_NAME}" -d"host=${TENANT_HOST}" http://${GLOBAL_HOST}/api/tenant/create)
output $STATUS 200 "Creating a tenant"

# Disable reCaptcha
STATUS=$(curl -k --silent --output /dev/null --write-out %{http_code} --cookie connect.sess=${ADMIN_COOKIE} -e "/" -d"oae-principals/recaptcha/enabled=false" http://${GLOBAL_HOST}/api/config)
output $STATUS 200 "Disabling reCaptcha"

# Configure SlideShare & Flickr
STATUS=$(curl -k --silent --output /dev/null --write-out %{http_code} --cookie connect.sess=${ADMIN_COOKIE} -e "/" -d"oae-preview-processor/flickr/apikey=0d7f5c9bd0277161d65dbea380a41ce2" -d"oae-preview-processor/flickr/apisecret=14a0bda0b8857ae0" -d"oae-preview-processor/slideshare/sharedsecret=CI5h3oQk" -d"oae-preview-processor/slideshare/apikey=d1ELqsL0" http://${GLOBAL_HOST}/api/config)
output $STATUS 200 "Configuring SlideShare & Flicker"

# Configure Google
STATUS=$(curl -k --silent --output /dev/null --write-out %{http_code} --cookie connect.sess=${ADMIN_COOKIE} -e "/" -d"oae-authentication/google/enabled=true" http://${GLOBAL_HOST}/api/config)
output $STATUS 200 "Configuring Google auth"

