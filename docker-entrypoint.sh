#!/bin/bash

set -e

if [ -z "$RABBITMQ_HOST" ]
then
    echo >&2 'error: missing RABBITMQ_HOST environment variables'
    exit 1
fi

if [ -z "$RABBITMQ_PORT" ]
then
    echo >&2 'error: missing RABBITMQ_PORT environment variables'
    exit 1
fi

if [ -z "$RABBITMQ_VHOST" ]
then
    echo >&2 'error: missing RABBITMQ_VHOST environment variables'
    exit 1
fi

if [ -z "$RABBITMQ_USER" ]
then
    echo >&2 'error: missing RABBITMQ_USER environment variables'
    exit 1
fi

if [ -z "$RABBITMQ_PASSWORD" ]
then
    echo >&2 'error: missing RABBITMQ_PASSWORD environment variables'
    exit 1
fi

if [ -z "$REDIS_HOST" ]
then
    echo >&2 'error: missing REDIS_HOST environment variables'
    exit 1
fi

if [ -z "$REDIS_PORT" ]
then
    echo >&2 'error: missing REDIS_PORT environment variables'
    exit 1
fi

if [ -z "$SENSU_API_HOST" ]
then
    echo >&2 'error: missing SENSU_API_BIND environment variables'
    exit 1
fi

if [ -z "$SENSU_API_BIND" ]
then
    echo >&2 'error: missing SENSU_API_BIND environment variables'
    exit 1
fi

if [ -z "$SENSU_API_PORT" ]
then
    echo >&2 'error: missing SENSU_API_PORT environment variables'
    exit 1
fi

if [ -z "$SENSU_COMPONENT" ]
then
    echo >&2 'error: missing SENSU_COMPONENT environment variables'
    exit 1
fi

sed \
    -i \
    -e "s#RABBITMQ_HOST#$RABBITMQ_HOST#" \
    -e "s#RABBITMQ_PORT#$RABBITMQ_PORT#" \
    -e "s#RABBITMQ_VHOST#$RABBITMQ_VHOST#" \
    -e "s#RABBITMQ_USER#$RABBITMQ_USER#" \
    -e "s#RABBITMQ_PASSWORD#$RABBITMQ_PASSWORD#" \
/etc/sensu/conf.d/rabbitmq.json

sed \
    -i \
    -e "s#REDIS_HOST#$REDIS_HOST#" \
    -e "s#REDIS_PORT#$REDIS_PORT#" \
/etc/sensu/conf.d/redis.json

sed \
    -i \
    -e "s#SENSU_API_HOST#$SENSU_API_HOST#" \
    -e "s#SENSU_API_BIND#$SENSU_API_BIND#" \
    -e "s#SENSU_API_PORT#$SENSU_API_PORT#" \
/etc/sensu/conf.d/api.json

# start - replacements in this block are optional

sed \
    -i \
    -e "s#HTTPS_PROXY#$HTTPS_PROXY#" \
    -e "s#HIPCHAT_API_KEY#$HIPCHAT_API_KEY" \
    -e "s#HIPCHAT_ROOM#$HIPCHAT_ROOM" \
/etc/sensu/conf.d/hipchat.json

sed \
    -i \
    -e "s#INFLUXDB_HOST#$INFLUXDB_HOST#" \
    -e "s#INFLUXDB_PORT#$INFLUXDB_PORT" \
    -e "s#INFLUXDB_USERNAME#$INFLUXDB_USERNAME" \
    -e "s#INFLUXDB_PASSWORD#$INFLUXDB_PASSWORD" \
    -e "s#INFLUXDB_DATABASE#$INFLUXDB_DATABASE" \
/etc/sensu/conf.d/influxdb.json

sed \
    -i \
    -e "s#AWS_ACCESS_KEY#$AWS_ACCESS_KEY#" \
    -e "s#AWS_SECRET_KEY#$AWS_SECRET_KEY" \
/etc/sensu/conf.d/aws_sns_auth.json

sed \
    -i \
    -e "s#SLACK_WEBHOOK_URL#$SLACK_WEBHOOK_URL#" \
/etc/sensu/conf.d/slack.json

# end - replacements in this block are optional

exec /opt/sensu/bin/sensu-$SENSU_COMPONENT -d /etc/sensu/conf.d,/etc/sensu/check.d,/etc/sensu/handlers.d,/etc/sensu/filters.d,/etc/sensu/remediations.d -e /etc/sensu/extensions.d -L warn

exec "$cmd"

