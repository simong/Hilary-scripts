#!/bin/bash

if [ "$1" = "--usage" ] ; then
    echo "Starts all the dependencies that are required to run Sakai OAE Hilary."
    echo "This assumes that all the required binaries can be found on the PATH environment variable.."
    echo "--------------------------------------------------------------"
    echo "./startDependencies.sh"
    echo "--------------------------------------------------------------"
    exit 0
fi

# Load shared functionality
source ./shared.sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
output 0 0 "Using ${DIR} as working space"
if [ ! -f "${DIR}/logs" ] ; then
    echo "Creating ${DIR}/logs"
    mkdir "${DIR}/logs"
fi


# Start Cassandra.
cassandra &> "${DIR}/logs/cassandra.log" &
output $? 0 "Started Cassandra"

# Start Redis
redis-server &> "${DIR}/logs/redis.log" &
output $? 0 "Started Redis"

# Start elastic search
cd /opt/sakai/oae/dependencies/elasticsearch
ES_CLASSPATH="target/classes:target/lib/* " ./target/bin/elasticsearch &
echo $! > "${DIR}/pids/elasticsearch.pid"
output $? 0 "Started Elasticsearch"

# Start RabbitMQ
rabbitmq-server -detached &> "${DIR}/logs/rabbit.log" &
output $? 0 "Started RabbitMQ server"

# Etherpad
# Sleep a bit so cassandra can start up
sleep 10
cd /opt/sakai/oae/test/etherpad-lite
node src/node/server.js > /dev/null &
