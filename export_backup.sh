#!/bin/bash -xv


make export-package stack_prefix=aem62test topic_config_file=topic_config.yaml message_config_file=inventory/group_vars/export-package.yaml details=params/export-package.json
