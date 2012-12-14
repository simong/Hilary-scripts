GLOBAL_HOST=admin.oae.com
TENANT_HOST=cam.oae.com


function output {
    if [ "$1" -eq "$2" ] ; then
        echo $'\e[32m' " ✓ $3"
    else
        echo $'\e[31m' "$3 - Expected: $2, Got: $1"
    fi
}

function code_without_response {
    echo ${1: -3:3}
}

function response_without_code {
    echo ${1:0:${#1} -3}
}

ADMIN_COOKIE=$(curl -s --cookie-jar - -d"username=administrator" -d"password=administrator" http://${GLOBAL_HOST}/api/auth/login | grep connect.sid | cut -f 7)
if [ -z "${ADMIN_COOKIE}" ] && [ "${ADMIN_COOKIE+xxx}" = "xxx" ] ; then 
    echo $'\e[31m' "Could not log in as an admin."
    exit 1;
fi