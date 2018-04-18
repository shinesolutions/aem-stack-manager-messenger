[![Build Status](https://img.shields.io/travis/shinesolutions/aem-stack-manager-messenger.svg)](http://travis-ci.org/shinesolutions/aem-stack-manager-messenger)

AEM Stack Manager Messenger
---------------------------

A set of [Ansible](https://www.ansible.com/) playbooks for triggering events on [AEM Stack Manager](https://github.com/shinesolutions/aem-stack-manager-cloud) environment which is built using [AEM AWS Stack Builder](https://github.com/shinesolutions/aem-aws-stack-builder).

Installation
------------

- Either clone AEM Stack Manager Messenger `git clone https://github.com/shinesolutions/aem-stack-manager-messenger.git` or download one of the [released versions](https://github.com/shinesolutions/aem-stack-manager-messenger/releases)
- Install the following required tools:
  * [Python](https://www.python.org/downloads/) version 2.7.x
- Resolve the [Python packages](https://github.com/shinesolutions/aem-stack-manager-messenger/blob/master/requirements.txt) dependencies by running `make deps`

Alternatively, you can use [AEM Platform BuildEnv](https://github.com/shinesolutions/aem-platform-buildenv) Docker container to run AEM Stack Manager Messenger build targets.

Usage
-----

Create [configuration file](https://github.com/shinesolutions/aem-stack-manager-messenger/blob/master/docs/configuration.md)

Execute the AEM Stack Manager events:

Deploy a set of AEM Packages and Dispatcher configuration packages into an AEM environment:

    make deploy-artifacts \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_stack_prefix> \
      config_path=<path/to/config/dir> \
      descriptor_file=deploy_descriptor_file.json

Deploy a single AEM Package into AEM instances:

    make deploy-artifact \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_stack_prefix> \
      config_path=<path/to/config/dir> \
      component=author-primary \
      source=s3://s3bucket/path/aem-helloworld-content-0.0.1-SNAPSHOT.zip \
      group=shinesolutions \
      name=aem-helloworld-content \
      version=0.0.1 \
      replicate=true \
      activate=false \
      force=true

Disable CRXDE on an AEM instance:

    make disable-crxde \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_stack_prefix> \
      config_path=<path/to/config/dir> \
      component=author-primary

Enable CRXDE on an AEM instance:

    make enable-crxde \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_stack_prefix> \
      config_path=<path/to/config/dir> \
      component=author-primary

Export a single AEM package from an AEM instance:

    make export-package \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_stack_prefix> \
      config_path=<path/to/config/dir> \
      component=author-primary \
      package_group=somegroup \
      package_name=somepackage \
      package_filter='[{"root":"/apps/geometrixx","rules":[]},{"root":"/apps/geometrixx-common","rules":[]}]'

Export a set of packages from an AEM instance via a descriptor file ([example](https://github.com/shinesolutions/aem-aws-stack-builder/blob/master/examples/descriptors/export-backup-descriptor.json)):

    make export-packages \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_stack_prefix>-cons \
      config_path=<path/to/config/dir> \
      descriptor_file=<export_backup_descriptor_file>

Flush dispatcher cache:

    make flush-dispatcher-cache \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_stack_prefix> \
      config_path=<path/to/config/dir> \
      component=publish-dispatcher

Trigger live snapshot of an AEM repository:

    make live-snapshot \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_stack_prefix> \
      config_path=<path/to/config/dir> \
      component=author-primary

Import a single AEM package into an AEM instance:

    make import-package \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_stack_prefix> \
      config_path=<path/to/config/dir> \
      component=author-primary \
      source_stack_prefix=stack2 \
      package_group=somegroup \
      package_name=somepackage \
      package_datestamp=201702

Promote an AEM Author Standby to become AEM Author Primary:

    make promote-author \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_stack_prefix> \
      config_path=<path/to/config/dir>

Take offline snapshot of the repositories within an AEM environment:

    make offline-snapshot \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_stack_prefix> \
      config_path=<path/to/config/dir>

Trigger offline compaction and take offline snapshot of the repositories within an AEM environment:

    make offline-compaction-snapshot \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_stack_prefix> \
      config_path=<path/to/config/dir>

Test readiness of AEM Full Set environment:

    make test-readiness-full-set \
      stack_prefix=<aem_fullset_stack_prefix> \
      config_path=<path/to/config/dir>

Test readiness of AEM Consolidated environment:

    make test-readiness-consolidated \
      stack_prefix=<aem_consolidated_stack_prefix> \
      config_path=<path/to/config/dir>
