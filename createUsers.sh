#!/bin/bash

if [ "$1" = "--usage" ] ; then
    echo "Creates <n> amount of users."
    echo "The defaults can be found after the colon for each parameter."
    echo "--------------------------------------------------------------"
    echo "./createUsers.sh <tenant host> <n:10> <username prefix:testuser>"
    echo "--------------------------------------------------------------"
    echo "Example:"
    echo ""
    echo "./createUser.sh cam.oae.com 10 testuser"
    echo "./createUser.sh cam.oae.com"
    echo "--------------------------------------------------------------"
    exit 0
fi

if [ $# -eq 0 ] ; then
    echo "You need to specify the tenant host."
    exit 1
fi

# Load shared functionality
source ./shared.sh

TENANT_HOST=$1
n=${2-10}
prefix=${3-testuser}

while [  $n -gt 0 ]; do
    ./createUser.sh ${TENANT_HOST} "${prefix}${n}"
    let n=n-1 
done