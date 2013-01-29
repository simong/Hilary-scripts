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
mkdir "${DIR}/logs"
mkdir "${DIR}/pids"

# Start Cassandra.
cassandra &> "${DIR}/logs/cassandra.log" &
echo $! > "${DIR}/pids/cassandra.pid"
output $? 0 "Started Cassandra"

# Start Redis
redis-server &> "${DIR}/logs/redis.log" &
echo $! > "${DIR}/pids/redis.pid"
output $? 0 "Started Redis"

# Start elastic search
elasticsearch &> "${DIR}/logs/elasticsearch.log" &
echo $! > "${DIR}/pids/elasticsearch.pid"
output $? 0 "Started Elasticsearch"

# Start RabbitMQ
rabbitmq-server -detached &> "${DIR}/logs/rabbit.log" &
echo $! > "${DIR}/pids/rabbmitmq.pid"
output $? 0 "Started RabbitMQ server"