# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

### Added
- Add release-major, release-minor, release-patch, and publish Makefile targets and GitHub Actions

## 2.14.1 - 2021-03-12
### Changed
- Update Ansible to 3.1.0

## 2.14.0 - 2021-03-02
### Changed
- Update Ansible to 3.0.0
- Update awscli to 1.19.8
- update boto3 to 1.17.8

### Fixed
- Fixed hosts to use python3 instead of python

## 2.13.0 - 2021-02-11
### Changed
- Lock down pylint to 2.6.0
- Use pip3 for python package management
- Convert python scripts to be executed using Python 3
- Set default Ansible Python interpreter to python3

## 2.12.0 - 2020-04-27
### Changed
- Update default executionTimeout for package deployment, export & import commands [shinesolutions/aem-aws-stack-builder#401]

## 2.11.0 - 2020-02-28
### Added
- Add new ssm parameter 'executionTimeout'

### Changed
- Changed offline-snapshot & offline-compatcion-snapshot default retries. It will now use the retries configured in the configuration profile

## 2.10.0 - 2020-01-20
### Changed
- Change integration test helloworld content package to use https://repo.maven.apache.org

## 2.9.0 - 2019-11-12
### Added
- Add feature to trigger Toughday2 performance test

### Changed
- Improved conditional checks when querying/scanning the DynamoDB [#77]

## 2.8.0 - 2019-08-20
### Added
- Add enable-saml and disable-saml

## 2.7.0 - 2019-08-14
### Changed
- Changed test-readiness-full-set template to send it only component orchestrator [#75]

### Removed
- Removed Make target for check-readiness-full-set-with-disabled-chaosmonkey [#75]
- Removed sns template check-readiness-full-set-with-disabled-chaosmonkey.json [#75]

## 2.6.0 - 2019-07-31
### Fixed
- Fixed issue with missing stage dir for sns message template file generation [#70]

## 2.5.0 - 2019-07-27
### Fixed
- Fixed offline-snapshot message sending sequence [#70]

## 2.4.2 - 2019-07-26
### Fixed
- Fixed offline-snapshot bug with resolving JSON template variables following upgrade to Ansible 2.8.x [#70]

## 2.4.1 - 2019-07-26
### Fixed
- Fixed bug with resolving JSON template variables following upgrade to Ansible 2.8.x [#70]

## 2.4.0 - 2019-07-21
### Added
- Add new make target to check stack readiness for stacks with disabled ChaosMonkey instance

## 2.3.1 - 2019-05-22
### Fixed
- Fix stack_prefix, target_aem_stack_prefix, and config_path variables assignment

## 2.3.0 - 2019-05-22
### Fixed
- Fix config_path variable assignment in run-playbook.sh script

## 2.2.1 - 2019-03-13
### Fixed
- Fix config path in run-playbook.sh script [#64]

## 2.2.0 - 2019-02-04
### Fixed
- Fix integration test config path since the introduction of profiles in aem-helloworld-config

## 2.1.0 - 2019-01-31
### Added
- Add Stack Manager events for AEM Upgrade automation.
- Add YAML checks to lint target

## 2.0.0 - 2018-12-07
### Changed
- Set test-readiness-full-set to run on all Full-Set architecture components

## 1.5.7 - 2018-11-05
### Added
- Add new Stack manager event to un/schedule live snapshot shinesolutions/aem-aws-stack-builder#212

## 1.5.6 - 2018-10-09
### Changed
- Fix SNS result message ID retrieval

## 1.5.5 - 2018-10-09
### Changed
- Fix missing region on AEM Stack existence check [#29]

## 1.5.4 - 2018-10-06
### Changed
- Change default logging to always dump log

## 1.5.3 - 2018-10-06
### Added
- Add feature to check if the target AEM Stack exists [#29]

### Changed
- Temporarily add unreleased ansible SNS module upgrade to boto3. [#59]

## 1.5.2 - 2018-09-11
### Removed
- Move all unschedule jobs to run at the beginning of the tests, all schedule jobs to run at the end

## 1.5.1 - 2018-08-19
### Added
- Add export-package & import-package to integration test

## 1.5.0 - 2018-07-31
### Added
- Add offline-snapshot, offline-compaction-snapshot for AEM Consolidated
- Add new Stack Manager event install-aem-profile

### Changed
- Rename offline-snapshot, offline-compaction-snapshot with full-set suffix
- Replace all check_message_sent usage with check_command_execution

### Removed
- Remove poll_timeout.check_message_sent.retries and poll_timeout.check_message_sent.delay configurations

## 1.4.1 - 2018-07-08
### Added
- Adding external id for SSM command execution

### Changed
- Improved error handling for SSM command execution

## 1.4.0 - 2018-05-24
### Changed
- Parameterise Stack Manager's main stack name [#44]
- Increase check command execution timeout to retry 720 times with 10 secs delay

## 1.3.1 - 2018-05-19
### Changed
- Check readiness no longer retries on failure now that Stack Manager event's SSM command ensures cloud-init completeness [#45]

## 1.3.0 - 2018-05-11
### Added
- Add message_config_file for author-publish-dispatcher
- Add poll_timeout.check_command_execution.retries and poll_timeout.check_command_execution.delay configurations [#31]
- Add command test-readiness-full-set
- Add command test-readiness-consolidated
- Add aem_id parameter to deploy-artifact and export-package message payloads
- Add poll_timeout.check_message_sent.retries and poll_timeout.check_message_sent.delay configurations
- Add show_log_on_failure_only configuration [#32]
- Add schedule/unschedule offline snapshot support

### Changed
- Replace topic_config parameter with config_path, which accepts a directory containing config files [#7]
- Fix export package message payload
- Simplify config by separating sns_topic into sns_topic.stack_manager and sns_topic.offline_snapshot
- Use stack_prefix parameter for Stack Manager stack prefix, introduce target_aem_stack_prefix for the actual AEM stack prefix [#37]
- Replace aws_region configuration with aws.region
- add command list-packages

### Removed
- Remove database table name, SNS topic ARNs, and S3 bucket configurations, they're now derived from stack prefix [#36]

## 1.2.2 - 2018-03-20
### Added
- Add payload files

## 1.2.1 - 2018-03-13
### Changed
- Improve the error handling for multi-step events (offline compaction and offline snapshot)

## 1.2.0 - 2018-03-08

## 1.1.0 - 2017-06-02
### Changed
- add source_stack_prefix to the import packages message
- new offline-compaction-snapshot message

## 1.0.0 - 2017-03-02
### Added
- Initial version
