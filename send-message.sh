#!/usr/bin/env bash

set -o errexit

run_id=${RUN_ID:-$(date +%Y-%m-%d:%H:%M:%S)}
log_path=logs/$run_id-send-message.log

# Construct Ansible extra_vars flags.
# If CONFIG_FILE is set, values will be added.
extra_vars=(--extra-vars "stack_prefix=$stack_prefix")
extra_vars+=(--extra-vars "descriptor_file=$descriptor_file")
extra_vars+=(--extra-vars "component=$component")
extra_vars+=(--extra-vars "artifact=$artifact")


# shellcheck disable=SC2154
if [ ! -z "$message_config_file" ]; then
  extra_vars+=(--extra-vars "@$message_config_file")
fi

# shellcheck disable=SC2154
if [ ! -z "$topic_config_file" ]; then
  extra_vars+=(--extra-vars "@$topic_config_file")
fi

mkdir -p logs
echo "Sending Message SNS Topic"
ANSIBLE_LOG_PATH=$log_path \
  ansible-playbook send-message.yaml \
  -i inventory/hosts \
  "${extra_vars[@]}"
echo "Finished Sending Message to SNS Topic"
