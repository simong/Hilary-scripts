#!/bin/bash

killall java
killall -9 redis-server
kill -9 `ps -ef | grep rabbitmq | grep -v 'grep' | cut -f 4 -d " "`