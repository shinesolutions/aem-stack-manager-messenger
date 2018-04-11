#!/usr/bin/env bash

set -o errexit

run_id=${RUN_ID:-$(date +%Y-%m-%d:%H:%M:%S)}
log_path=logs/$run_id-send-message.log

# Construct Ansible extra_vars flags.
# If CONFIG_FILE is set, values will be added.

extra_vars=(--extra-vars "stack_prefix=$stack_prefix message_type=$message_type")

# shellcheck disable=SC2154
extra_vars+=(--extra-vars "@$config_path")

if [ ! -z "$4" ]; then
    extra_vars+=(--extra-vars "$4")
fi

mkdir -p logs
echo "Sending Message SNS Topic..."
ANSIBLE_CONFIG=ansible/ansible.cfg \
  ANSIBLE_LOG_PATH=$log_path \
  ansible-playbook ansible/playbooks/offline-compaction-snapshot.yaml \
  -v \
  -i ansible/inventory/hosts \
  --module-path ansible/library/ \
  "${extra_vars[@]}"
echo "Finished Sending Message to SNS Topic"
