#!/bin/bash -xv


make deploy-artifacts stack_prefix=aem62test topic_config_file=topic_config.yaml \
     message_config_file=inventory/group_vars/deploy-artifacts.yaml \
     details=params/deploy-artifacts.json
