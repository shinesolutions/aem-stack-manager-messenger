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

Deploy a set of AEM Packages and Dispatcher artifacts into an AEM environment using a [deployment descriptor](https://github.com/shinesolutions/aem-aws-stack-builder/blob/master/docs/descriptor-deployment.md) file:

    make deploy-artifacts-full-set \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_full_set_stack_prefix> \
      config_path=<path/to/config/dir> \
      descriptor_file=deploy-artifacts-descriptor.json

    make deploy-artifacts-consolidated \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_consolidated_stack_prefix> \
      config_path=<path/to/config/dir> \
      descriptor_file=deploy-artifacts-descriptor.json

Deploy a single AEM Package into an AEM instance:

    make deploy-artifact \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_stack_prefix> \
      config_path=<path/to/config/dir> \
      component=author-primary \
      aem_id=author \
      source=s3://s3bucket/path/aem-helloworld-content-0.0.1-SNAPSHOT.zip \
      group=shinesolutions \
      name=aem-helloworld-content \
      version=0.0.1 \
      replicate=true \
      activate=false \
      force=true

Enable CRXDE on an AEM instance:

    make enable-crxde \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_stack_prefix> \
      config_path=<path/to/config/dir> \
      component=author-primary

Disable CRXDE on an AEM instance:

    make disable-crxde \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_stack_prefix> \
      config_path=<path/to/config/dir> \
      component=author-primary

Export a set of packages from an AEM instance using an [export descriptor](https://github.com/shinesolutions/aem-aws-stack-builder/blob/master/docs/descriptor-export.md) file:

    make export-packages-full-set \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_full_set_stack_prefix> \
      config_path=<path/to/config/dir> \
      descriptor_file=<export_backup_descriptor_file>

    make export-packages-consolidated \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_consolidated_stack_prefix> \
      config_path=<path/to/config/dir> \
      descriptor_file=<export_backup_descriptor_file>

Export a single AEM package from an AEM instance:

    make export-package \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_stack_prefix> \
      config_path=<path/to/config/dir> \
      component=author-primary \
      package_group=somegroup \
      package_name=somepackage \
      package_filter='[{"root":"/apps/geometrixx","rules":[]},{"root":"/apps/geometrixx-common","rules":[]}]'

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

List AEM packages available on an AEM instance:

    make list-packages \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_stack_prefix> \
      config_path=<path/to/config/dir> \
      component=author-primary

Promote an AEM Author Standby to become AEM Author Primary:

    make promote-author \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_stack_prefix> \
      config_path=<path/to/config/dir>

Take live snapshot of the repositories within an AEM component:

    make live-snapshot \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_stack_prefix> \
      config_path=<path/to/config/dir> \
      component=author-primary

Take offline snapshots of a single AEM Author and a single AEM Publish repositories within an AEM environment (See offline-snapshot-full-set):

    make offline-snapshot \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_stack_prefix> \
      config_path=<path/to/config/dir>

Take offline snapshots of a single AEM Author and a single AEM Publish repositories within an AEM environment and run offline compaction on those AEM instances (See offline-compaction-snapshot-full-set):

    make offline-compaction-snapshot \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_stack_prefix> \
      config_path=<path/to/config/dir>

Take offline snapshots of a single AEM Author and a single AEM Publish repositories within an AEM environment (currently only supports Full-Set):

    make offline-snapshot-full-set \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_stack_prefix> \
      config_path=<path/to/config/dir>

Take offline snapshots of a single AEM Author and a single AEM Publish repositories within an AEM environment and run offline compaction on those AEM instances (currently only supports Full-Set):

    make offline-compaction-snapshot-full-set \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_stack_prefix> \
      config_path=<path/to/config/dir>

Check readiness of an AEM environment:

    make check-readiness-full-set \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_full_set_stack_prefix> \
      config_path=<path/to/config/dir>

    make check-readiness-consolidated \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_consolidated_stack_prefix> \
      config_path=<path/to/config/dir>

Schedule/unschedule jobs on an AEM environment:

    make schedule-offline-snapshot-full-set \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_full_set_stack_prefix> \
      config_path=<path/to/config/dir>

    make unschedule-offline-snapshot-full-set \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_full_set_stack_prefix> \
      config_path=<path/to/config/dir>

    make schedule-offline-compaction-snapshot-full-set \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_full_set_stack_prefix> \
      config_path=<path/to/config/dir>

    make unschedule-offline-compaction-snapshot-full-set \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_full_set_stack_prefix> \
      config_path=<path/to/config/dir>

    make schedule-offline-snapshot-consolidated \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_consolidated_stack_prefix> \
      config_path=<path/to/config/dir>

    make unschedule-offline-snapshot-consolidated \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_consolidated_stack_prefix> \
      config_path=<path/to/config/dir>

    make schedule-offline-compaction-snapshot-consolidated \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_consolidated_stack_prefix> \
      config_path=<path/to/config/dir>

    make unschedule-offline-compaction-snapshot-consolidated \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_consolidated_stack_prefix> \
      config_path=<path/to/config/dir>

Testing
-------

Run integration tests of all Stack Manager events against an AEM Full-Set architecture:

    make test-full-set \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_full_set_stack_prefix>

Run integration tests of all Stack Manager events against an AEM Consolidated architecture:

    make test-consolidated \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_consolidated_stack_prefix>
