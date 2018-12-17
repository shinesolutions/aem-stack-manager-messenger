# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
* Add Stack Manager events for AEM Upgrade automation.
- Add YAML checks to lint target

## [2.0.0] - 2018-12-07

### Changed
- Set test-readiness-full-set to run on all Full-Set architecture components

## [1.5.7] - 2018-11-05

### Added
- Add new Stack manager event to un/schedule live snapshot shinesolutions/aem-aws-stack-builder#212

## [1.5.6] - 2018-10-09

### Changed
- Fix SNS result message ID retrieval

## [1.5.5] - 2018-10-09

### Changed
- Fix missing region on AEM Stack existence check #29

## [1.5.4] - 2018-10-06

### Changed
- Change default logging to always dump log

## [1.5.3] - 2018-10-06

### Added
- Add feature to check if the target AEM Stack exists #29

### Changed
- Temporarily add unreleased ansible SNS module upgrade to boto3. #59

## [1.5.2] - 2018-09-11

### Removed
- Move all unschedule jobs to run at the beginning of the tests, all schedule jobs to run at the end

## [1.5.1] - 2018-08-19

### Added
- Add export-package & import-package to integration test

## [1.5.0] - 2018-07-31

### Added
- Add offline-snapshot, offline-compaction-snapshot for AEM Consolidated
- Add new Stack Manager event install-aem-profile

### Changed
- Rename offline-snapshot, offline-compaction-snapshot with full-set suffix
- Replace all check_message_sent usage with check_command_execution

### Removed
- Remove poll_timeout.check_message_sent.retries and poll_timeout.check_message_sent.delay configurations

## [1.4.1] - 2018-07-08

### Added
- Adding external id for SSM command execution

### Changed
- Improved error handling for SSM command execution

## [1.4.0] - 2018-05-24

### Changed
- Parameterise Stack Manager's main stack name #44
- Increase check command execution timeout to retry 720 times with 10 secs delay

## [1.3.1] - 2018-05-19

### Changed
- Check readiness no longer retries on failure now that Stack Manager event's SSM command ensures cloud-init completeness #45

## [1.3.0] - 2018-05-11

### Added
- Add message_config_file for author-publish-dispatcher
- Add poll_timeout.check_command_execution.retries and poll_timeout.check_command_execution.delay configurations #31
- Add command test-readiness-full-set
- Add command test-readiness-consolidated
- Add aem_id parameter to deploy-artifact and export-package message payloads
- Add poll_timeout.check_message_sent.retries and poll_timeout.check_message_sent.delay configurations
- Add show_log_on_failure_only configuration #32
- Add schedule/unschedule offline snapshot support

### Changed
- Replace topic_config parameter with config_path, which accepts a directory containing config files #7
- Fix export package message payload
- Simplify config by separating sns_topic into sns_topic.stack_manager and sns_topic.offline_snapshot
- Use stack_prefix parameter for Stack Manager stack prefix, introduce target_aem_stack_prefix for the actual AEM stack prefix #37
- Replace aws_region configuration with aws.region
- add command list-packages

### Removed
- Remove database table name, SNS topic ARNs, and S3 bucket configurations, they're now derived from stack prefix #36

## [1.2.2] - 2018-03-20

### Added
- Add payload files

## [1.2.1] - 2018-03-13

### Changed
- Improve the error handling for multi-step events (offline compaction and offline snapshot)

## [1.2.0] - 2018-03-08

## [1.1.0] - 2017-06-02

### Changed
- add source_stack_prefix to the import packages message
- new offline-compaction-snapshot message

## [1.0.0] - 2017-03-02

### Added
- Initial version
