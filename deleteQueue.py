from amqplib import client_0_8 as amqp
import sys

try:
    conn = amqp.Connection(host="localhost:5672", virtual_host="/", insist=False)
    conn = conn.channel()
    conn.queue_delete(sys.argv[1])
except amqp.exceptions.AMQPChannelException as e:
    if e.amqp_reply_code != 404:
        raise e