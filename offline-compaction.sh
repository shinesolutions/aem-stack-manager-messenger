#!/bin/bash -xv


make offline-compaction-snapshot stack_prefix=aem62test topic_config_file=topic_config.yaml message_config_file=inventory/group_vars/offline-compaction-snapshot.yaml
