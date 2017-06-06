#!/bin/bash

make deploy-artifact stack_prefix=aem62test topic_config_file=topic_config.yaml message_config_file=inventory/group_vars/deploy-artifact.yaml package_source=s3://mb-aem-stack-builder/aem62test/acs-aem-commons-content-3.9.0.zip component=author-primary package_group=adobe/consulting package_name=acs-aem-commons-content package_version=3.9.0 replicate=false activate=false force=true
