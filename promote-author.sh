#!/bin/bash -xv


make promote-author stack_prefix=aem62test topic_config_file=topic_config.yaml \
     message_config_file=inventory/group_vars/promote-author.yaml
