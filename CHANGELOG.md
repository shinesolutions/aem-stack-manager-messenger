### 1.5.9
*

### 1.5.8
* Set test-readiness-full-set to run on all Full-Set architecture components

### 1.5.7
* Add new Stack manager event to un/schedule live snapshot shinesolutions/aem-aws-stack-builder#212

### 1.5.6
* Fix SNS result message ID retrieval

### 1.5.5
* Fix missing region on AEM Stack existence check #29

### 1.5.4
* Change default logging to always dump log

### 1.5.3
* Temporarily add unreleased ansible SNS module upgrade to boto3. #59
* Add feature to check if the target AEM Stack exists #29

### 1.5.2
* Move all unschedule jobs to run at the beginning of the tests, all schedule jobs to run at the end

### 1.5.1
* Add export-package & import-package to integration test

### 1.5.0
* Rename offline-snapshot, offline-compaction-snapshot with full-set suffix
* Add offline-snapshot, offline-compaction-snapshot for AEM Consolidated
* Add new Stack Manager event install-aem-profile
* Remove poll_timeout.check_message_sent.retries and poll_timeout.check_message_sent.delay configurations
* Replace all check_message_sent usage with check_command_execution

### 1.4.1
* Adding external id for SSM command execution
* Improved error handling for SSM command execution

### 1.4.0
* Parameterise Stack Manager's main stack name #44
* Increase check command execution timeout to retry 720 times with 10 secs delay

### 1.3.1
* Check readiness no longer retries on failure now that Stack Manager event's SSM command ensures cloud-init completeness #45

### 1.3.0
* Add message_config_file for author-publish-dispatcher
* Add poll_timeout.check_command_execution.retries and poll_timeout.check_command_execution.delay configurations #31
* Add command test-readiness-full-set
* Add command test-readiness-consolidated
* Replace topic_config parameter with config_path, which accepts a directory containing config files #7
* Add aem_id parameter to deploy-artifact and export-package message payloads
* Fix export package message payload
* Add poll_timeout.check_message_sent.retries and poll_timeout.check_message_sent.delay configurations
* Simplify config by separating sns_topic into sns_topic.stack_manager and sns_topic.offline_snapshot
* Use stack_prefix parameter for Stack Manager stack prefix, introduce target_aem_stack_prefix for the actual AEM stack prefix #37
* Remove database table name, SNS topic ARNs, and S3 bucket configurations, they're now derived from stack prefix #36
* Replace aws_region configuration with aws.region
* Add show_log_on_failure_only configuration #32
* add command list-packages
* Add schedule/unschedule offline snapshot support

### 1.2.2
* Add payload files

### 1.2.1
* Improve the error handling for multi-step events (offline compaction and offline snapshot)

### 1.2.0
 * add command enable-crxde
 * add command live-snapshot
 * add command export-packages
 * add polling state of the sent command
 * add ansible module to output the log of the sent command to stdout
 * add ansible playbook for offline-snapshot and offline-compaction-snapshot
 * add new command flush-dispatcher-cache
 * Improvement of the error handling
 * Update Ansible playbooks to improve flexibility of AEM Stack Manager

### 1.1.0
* add source_stack_prefix to the import packages message
* new offline-compaction-snapshot message

### 1.0.0
* Initial version
