#!/bin/bash

if [ "$1" = "--usage" ] ; then
    echo "Flushes all the data."
    echo "--------------------------------------------------------------"
    echo "./flushDependencies.sh"
    echo "--------------------------------------------------------------"
    exit 0
fi

source ./shared.sh

# Flush cassandra
cqlsh -f dropOaeKeyspace.cql &> /dev/null 1>&2
output $? 0 "Dropped the OAE keyspace"

# Flush Redis
redis-cli flushdb &> /dev/null 1>&2
output $? 0 "Flushed the Redis cache"

# Delete the ElasticSearch index
curl -X DELETE http://localhost:9200/oae &> /dev/null 1>&2
output $? 0 "Deleted the ElasticSearch index"

rabbitmqctl stop_app
rabbitmqctl reset
rabbitmqctl start_app
#rabbitmqctl set_policy ha-all "^oae-" '{"ha-mode":"all"}'

# Flush the rabbitmq queue.
#python deleteQueue.py "oae-preview-processor/generatePreviews" &> /dev/null 1>&2
#output $? 0 "Dropped the previews queue"
#python deleteQueue.py "oae-search/delete" &> /dev/null 1>&2
#output $? 0 "Dropped the delete search queue"
#python deleteQueue.py "oae-search/index" &> /dev/null 1>&2
#output $? 0 "Dropped the index search queue"