#!/bin/bash -xv


make import-package stack_prefix=aem62dev topic_config_file=topic_config.yaml message_config_file=inventory/group_vars/import-package.yaml details=params/import-package.json
