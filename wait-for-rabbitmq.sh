#!/bin/bash
set -e

host="$1"
port="$2"
max_retries=30
retry_delay=5

shift 2
service cron start
cmd="$@"

echo "Checking RabbitMQ connectivity..."

until nc -z "$host" "$port" || [ $max_retries -eq 0 ]; do
  echo "RabbitMQ is not ready yet. Retrying in $retry_delay seconds... ($max_retries retries left)"
  sleep "$retry_delay"
  ((max_retries--))
done

if [ $max_retries -eq 0 ]; then
  echo "Failed to connect to RabbitMQ after 30 attempts, exiting..."
  exit 1
fi

echo "RabbitMQ is up and running!"
exec $cmd