#!/usr/bin/env bash

set -o errexit

STACK_PREFIX="$1"
TARGET_AEM_STACK_PREFIX="$2"

CONFIG_PATH=examples/user-config/

AEM_PACKAGE_GROUP=shinesolutions
AEM_PACKAGE_NAME=aem-helloworld-content
AEM_PACKAGE_VERSION=0.0.1
AEM_PACKAGE_URL="http://central.maven.org/maven2/com/$AEM_PACKAGE_GROUP/$AEM_PACKAGE_NAME/$AEM_PACKAGE_VERSION/$AEM_PACKAGE_NAME-$AEM_PACKAGE_VERSION.zip"

##################################################
# Test AEM Full-Set Architecture readiness
##################################################

make test-readiness-full-set \
  stack_prefix="$STACK_PREFIX" \
  target_aem_stack_prefix="$TARGET_AEM_STACK_PREFIX" \
  config_path="$CONFIG_PATH"

# ##################################################
# # List packages on AEM Author
# ##################################################
#
# make list-packages \
#   stack_prefix="$STACK_PREFIX" \
#   target_aem_stack_prefix="$TARGET_AEM_STACK_PREFIX" \
#   config_path="$CONFIG_PATH" \
#   component=author
#
# ##################################################
# # List packages on AEM Publish
# ##################################################
#
# make list-packages \
#   stack_prefix="$STACK_PREFIX" \
#   target_aem_stack_prefix="$TARGET_AEM_STACK_PREFIX" \
#   config_path="$CONFIG_PATH" \
#   component=publish

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

##################################################
# Enable and disable CRXDE on AEM Publish
##################################################

make enable-crxde \
  stack_prefix="$STACK_PREFIX" \
  target_aem_stack_prefix="$TARGET_AEM_STACK_PREFIX" \
  config_path="$CONFIG_PATH" \
  component=publish

make disable-crxde \
  stack_prefix="$STACK_PREFIX" \
  target_aem_stack_prefix="$TARGET_AEM_STACK_PREFIX" \
  config_path="$CONFIG_PATH" \
  component=publish

##################################################
# Flush AEM Author-Dispatcher cache
##################################################

make flush-dispatcher-cache \
  stack_prefix="$STACK_PREFIX" \
  target_aem_stack_prefix="$TARGET_AEM_STACK_PREFIX" \
  config_path="$CONFIG_PATH" \
  component=author-dispatcher

##################################################
# Flush AEM Publish-Dispatcher cache
##################################################

make flush-dispatcher-cache \
  stack_prefix="$STACK_PREFIX" \
  target_aem_stack_prefix="$TARGET_AEM_STACK_PREFIX" \
  config_path="$CONFIG_PATH" \
  component=publish-dispatcher

##################################################
# Deploy a set of artifacts to AEM Full-Set Architecture
##################################################

make deploy-artifacts-full-set \
  stack_prefix="$STACK_PREFIX" \
  target_aem_stack_prefix="$TARGET_AEM_STACK_PREFIX" \
  config_path="$CONFIG_PATH" \
  descriptor_file=deploy-artifacts-descriptor.json

##################################################
# Deploy a single AEM package to AEM Author
##################################################

make deploy-artifact \
  stack_prefix="$STACK_PREFIX" \
  target_aem_stack_prefix="$TARGET_AEM_STACK_PREFIX" \
  config_path="$CONFIG_PATH" \
  component=author-primary \
  aem_id=author \
  source="$AEM_PACKAGE_URL" \
  group="$AEM_PACKAGE_GROUP" \
  name="$AEM_PACKAGE_NAME" \
  version="$AEM_PACKAGE_VERSION" \
  replicate=true \
  activate=false \
  force=true

##################################################
# Deploy a single AEM package to AEM Publish
##################################################

make deploy-artifact \
  stack_prefix="$STACK_PREFIX" \
  target_aem_stack_prefix="$TARGET_AEM_STACK_PREFIX" \
  config_path="$CONFIG_PATH" \
  component=publish \
  aem_id=publish \
  source="$AEM_PACKAGE_URL" \
  group="$AEM_PACKAGE_GROUP" \
  name="$AEM_PACKAGE_NAME" \
  version="$AEM_PACKAGE_VERSION" \
  replicate=false \
  activate=false \
  force=true

##################################################
# Take live snapshot of AEM Author repositories
##################################################

make live-snapshot \
  stack_prefix="$STACK_PREFIX" \
  target_aem_stack_prefix="$TARGET_AEM_STACK_PREFIX" \
  config_path="$CONFIG_PATH" \
  component=author-primary

make live-snapshot \
  stack_prefix="$STACK_PREFIX" \
  target_aem_stack_prefix="$TARGET_AEM_STACK_PREFIX" \
  config_path="$CONFIG_PATH" \
  component=author-standby

##################################################
# Take live snapshot of AEM Publish repositories
##################################################

make live-snapshot \
  stack_prefix="$STACK_PREFIX" \
  target_aem_stack_prefix="$TARGET_AEM_STACK_PREFIX" \
  config_path="$CONFIG_PATH" \
  component=publish

##################################################
# Offline snapshot AEM Full-Set Architecture
##################################################

# make test-readiness-full-set \
#   stack_prefix="$STACK_PREFIX" \
#   target_aem_stack_prefix="$TARGET_AEM_STACK_PREFIX" \
#   config_path="$CONFIG_PATH"
#
# make offline-snapshot \
#   stack_prefix="$STACK_PREFIX" \
#   target_aem_stack_prefix="$TARGET_AEM_STACK_PREFIX" \
#   config_path="$CONFIG_PATH"
#
# make test-readiness-full-set \
#   stack_prefix="$STACK_PREFIX" \
#   target_aem_stack_prefix="$TARGET_AEM_STACK_PREFIX" \
#   config_path="$CONFIG_PATH"
