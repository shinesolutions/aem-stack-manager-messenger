[![Build Status](https://img.shields.io/travis/shinesolutions/aem-stack-manager-messenger.svg)](http://travis-ci.org/shinesolutions/aem-stack-manager-messenger)
[![Known Vulnerabilities](https://snyk.io/test/github/shinesolutions/aem-stack-manager-messenger/badge.svg)](https://snyk.io/test/github/shinesolutions/aem-stack-manager-messenger)

AEM Stack Manager Messenger
---------------------------

A set of [Ansible](https://www.ansible.com/) playbooks for triggering events on [AEM Stack Manager](https://github.com/shinesolutions/aem-stack-manager-cloud) environment which is built using [AEM AWS Stack Builder](https://github.com/shinesolutions/aem-aws-stack-builder).

Learn more about AEM Stack Manager Messenger:

* [Installation](https://github.com/shinesolutions/aem-stack-manager-messenger#installation)
* [Configuration](https://github.com/shinesolutions/aem-stack-manager-messenger/blob/master/docs/configuration.md)
* [Usage](https://github.com/shinesolutions/aem-stack-manager-messenger#usage)
* [Testing](https://github.com/shinesolutions/aem-stack-manager-messenger#testing)
* [Frequently Asked Questions](https://github.com/shinesolutions/aem-stack-manager-messenger/blob/master/docs/faq.md)

AEM Stack Manager Messenger is part of [AEM OpenCloud](https://aemopencloud.io) platform.

Installation
------------

- Either clone AEM Stack Manager Messenger `git clone https://github.com/shinesolutions/aem-stack-manager-messenger.git` or download one of the [released versions](https://github.com/shinesolutions/aem-stack-manager-messenger/releases)
- Install the following required tools:
  * [Python](https://www.python.org/downloads/) version 2.7.x
  * [GNU Make](https://www.gnu.org/software/make/)<br/>

  Alternatively, you can use [AEM Platform BuildEnv](https://github.com/shinesolutions/aem-platform-buildenv) Docker container to run AEM Stack Manager Messenger build targets.
- Resolve the [Python packages](https://github.com/shinesolutions/aem-stack-manager-messenger/blob/master/requirements.txt) dependencies by running `make deps`

Usage
-----

- Create [configuration file](https://github.com/shinesolutions/aem-stack-manager-messenger/blob/master/docs/configuration.md)
- Execute the AEM Stack Manager events:

Deploy a set of AEM Packages and Dispatcher artifacts into an AEM environment using a [Deployment Descriptor](https://github.com/shinesolutions/aem-aws-stack-builder/blob/master/docs/descriptors.md#deployment-descriptor) file:

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

Disable SAML on an AEM instance:

  make disable-saml \
    stack_prefix=<stack_manager_stack_prefix> \
    target_aem_stack_prefix=<aem_stack_prefix> \
    config_path=<path/to/config/dir> \
    component=author-primary \
    aem_id=author path='/'

Enable SAML with filepath to SAML certificate on an AEM instance:

  make enable-saml \
    stack_prefix=<stack_manager_stack_prefix> \
    target_aem_stack_prefix=<aem_stack_prefix> \
    config_path=<path/to/config/dir> \
    component=author-primary \
    aem_id=author path='/' \
    file="s3://aem-opencloud/adobeaemcloud/certs/saml_cert.pem" \
    assertion_consumer_service_url="https://author.aemopencloud.net:443/saml_login" \
    service_provider_entity_id=AEMSSO \
    idp_url="https://federation.server.com" \
    create_user=true \
    default_groups=content-authors \
    group_membership_attribute=groupMembership \
    handle_logout=true \
    idp_http_redirect=false \
    logout_url="https://accounts.google.com/logout" \
    name_id_format='urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress' \
    signature_method="http://www.w3.org/2001/04/xmldsig-more#rsa-sha256" \
    synchronize_attributes="givenName=profile/givenName,familyName=profile/familyName,mail=profile/email" \
    use_encryption=false \
    user_id_attribute=NameID

Enable SAML with IDP Certalias of the SAML certificate as in the AEM Truststore on an AEM instance:

  make enable-saml \
    stack_prefix=<stack_manager_stack_prefix> \
    target_aem_stack_prefix=<aem_stack_prefix> \
    config_path=<path/to/config/dir> \
    component=author-primary \
    aem_id=author path='/' \
    idp_cert_alias='certalias_1234' \
    assertion_consumer_service_url="https://author.aemopencloud.net:443/saml_login" \
    service_provider_entity_id=AEMSSO \
    idp_url="https://federation.server.com" \
    create_user=true \
    default_groups=content-authors \
    group_membership_attribute=groupMembership \
    handle_logout=true \
    idp_http_redirect=false \
    logout_url="https://accounts.google.com/logout" \
    name_id_format='urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress' \
    signature_method="http://www.w3.org/2001/04/xmldsig-more#rsa-sha256" \
    synchronize_attributes="givenName=profile/givenName,familyName=profile/familyName,mail=profile/email" \
    use_encryption=false \
    user_id_attribute=NameID

Enable SAML with defined SERIAL number of the SAML certificate on an AEM instance:

  make enable-saml \
    stack_prefix=<stack_manager_stack_prefix> \
    target_aem_stack_prefix=<aem_stack_prefix> \
    config_path=<path/to/config/dir> \
    component=author-primary \
    aem_id=author path='/' \
    serial='1234567890' \
    assertion_consumer_service_url="https://author.aemopencloud.net:443/saml_login" \
    service_provider_entity_id=AEMSSO \
    idp_url="https://federation.server.com" \
    create_user=true \
    default_groups=content-authors \
    group_membership_attribute=groupMembership \
    handle_logout=true \
    idp_http_redirect=false \
    logout_url="https://accounts.google.com/logout" \
    name_id_format='urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress' \
    signature_method="http://www.w3.org/2001/04/xmldsig-more#rsa-sha256" \
    synchronize_attributes="givenName=profile/givenName,familyName=profile/familyName,mail=profile/email" \
    use_encryption=false \
    user_id_attribute=NameID

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

Export a set of backup packages from an AEM instance using a [Package Backup Descriptor](https://github.com/shinesolutions/aem-aws-stack-builder/blob/master/docs/descriptors.md#package-backup-descriptor) file:

    make export-packages-full-set \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_full_set_stack_prefix> \
      config_path=<path/to/config/dir> \
      descriptor_file=<package_backup_descriptor_file>

    make export-packages-consolidated \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_consolidated_stack_prefix> \
      config_path=<path/to/config/dir> \
      descriptor_file=<package_backup_descriptor_file>

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

Take offline snapshots of a single AEM Author and a single AEM Publish repositories within an AEM Consolidated instance:

    make offline-snapshot-consolidated \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_stack_prefix> \
      config_path=<path/to/config/dir>

Take offline snapshots of a single AEM Author and a single AEM Publish repositories within an AEM Consolidated instance and run offline compaction on the AEM instance:

    make offline-compaction-snapshot-consolidated \
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

Upgrade AEM environment to a new version on AEM environment:
    AEM Upgrade preparation step 1 download AEM e.g. AEM 6.4 jar file and unpack it

    make upgrade-unpack-jar \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_consolidated_stack_prefix> \
      config_path=<path/to/config/dir> \
      component=author-publish-dispatcher \
      aem_artifacts_base="s3://aem-opencloud/adobeaemcloud" \
      aem_upgrade_version="6.4" \
      enable_backup=false

    AEM Upgrade preparation step 2 run repository migration

    make upgrade-unpack-jar \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_consolidated_stack_prefix> \
      config_path=<path/to/config/dir> \
      component=author-publish-dispatcher \
      source_crx2oak="https://repo.adobe.com/nexus/content/groups/public/com/adobe/granite/crx2oak/1.8.6/crx2oak-1.8.6-all-in-one.jar"

    Trigger the AEM Upgrade to specified version:

    make upgrade-unpack-jar \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_consolidated_stack_prefix> \
      config_path=<path/to/config/dir> \
      component=author-publish-dispatcher \
       aem_upgrade_version="6.4"

Testing
-------

You can run integration test for running all AEM Stack Manager events for a given AEM architecture, using the latest [AEM Hello World Config](https://github.com/shinesolutions/aem-helloworld-config) from GitHub.

Run integration tests for AEM Full-Set architecture:

    make test-full-set \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_full_set_stack_prefix>

Run integration tests for AEM Consolidated architecture:

    make test-consolidated \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_consolidated_stack_prefix>

Alternatively, you can also run the integration tests using a local AEM Hello World Config.

    make test-full-set-local \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_full_set_stack_prefix>

    make test-consolidated-local \
      stack_prefix=<stack_manager_stack_prefix> \
      target_aem_stack_prefix=<aem_consolidated_stack_prefix>
