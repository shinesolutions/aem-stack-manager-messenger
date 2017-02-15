#!/usr/bin/env bash

set -o errexit

run_id=${RUN_ID:-$(date +%Y-%m-%d:%H:%M:%S)}
log_path=logs/$run_id-send-message.log

# Construct Ansible extra_vars flags.
# If CONFIG_FILE is set, values will be added.

extra_vars=(--extra-vars "stack_prefix=$stack_prefix")

# shellcheck disable=SC2154
extra_vars+=(--extra-vars "@$topic_config_file")

# shellcheck disable=SC2154
extra_vars+=(--extra-vars "@$message_config_file")

if [ ! -z "$4" ]; then
    extra_vars+=(--extra-vars "$4")
fi

mkdir -p logs
echo "Sending Message SNS Topic"
ANSIBLE_LOG_PATH=$log_path \
  ansible-playbook send-message.yaml \
  -v \
  -i inventory/hosts \
  "${extra_vars[@]}"
echo "Finished Sending Message to SNS Topic"
