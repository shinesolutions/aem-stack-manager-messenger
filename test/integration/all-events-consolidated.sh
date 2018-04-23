#!/usr/bin/env bash

set -o errexit

STACK_PREFIX="$1"
TARGET_AEM_STACK_PREFIX="$2"

CONFIG_PATH=examples/user-config/

# AEM_PACKAGE_GROUP=shinesolutions
# AEM_PACKAGE_NAME=aem-helloworld-content
# AEM_PACKAGE_VERSION=0.0.1
# AEM_PACKAGE_URL="http://central.maven.org/maven2/com/$AEM_PACKAGE_GROUP/$AEM_PACKAGE_NAME/$AEM_PACKAGE_VERSION/$AEM_PACKAGE_NAME-$AEM_PACKAGE_VERSION.zip"

##################################################
# Check AEM Full-Set Architecture readiness
##################################################

# make check-readiness-consolidated \
#   stack_prefix="$STACK_PREFIX" \
#   target_aem_stack_prefix="$TARGET_AEM_STACK_PREFIX" \
#   config_path="$CONFIG_PATH"

##################################################
# Enable and disable CRXDE on AEM Author
##################################################

make enable-crxde \
  stack_prefix="$STACK_PREFIX" \
  target_aem_stack_prefix="$TARGET_AEM_STACK_PREFIX" \
  config_path="$CONFIG_PATH" \
  component=author-primary

make disable-crxde \
  stack_prefix="$STACK_PREFIX" \
  target_aem_stack_prefix="$TARGET_AEM_STACK_PREFIX" \
  config_path="$CONFIG_PATH" \
  component=author-primary
