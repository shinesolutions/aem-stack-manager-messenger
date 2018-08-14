Configuration
-------------

The following configurations are available for users to customise Stack Manager event processing.

Check out the [example configuration files](https://github.com/shinesolutions/aem-stack-manager-messenger/blob/master/examples/user-config/) as reference.

| Name | Description | Required? | Default |
|------|-------------|-----------|---------|
| show_log_on_failure_only | If set to true, log will only be displayed when there is a failure. If set to false, all logs will be displayed regardless of success or failure. The logs here are the output/error generated from executing the SSM command for a given Stack Manager event, e.g. if the event is `deploy-artifacts-consolidated`, then the log will contain the output/error from deploying the artifacts into the corresponding AEM Consolidated environment. | Optional | true |
| poll_timeout.check_command_execution.retries | The number of times it will check the status of command execution until there is a success or a failure. | Optional | 720 |
| poll_timeout.check_command_execution.delay | The duration (in seconds) between command execution checks. | Optional | 10 |
| main.stack_name | The Stack Manager's main stack name, it should be identical to the Stack Manager's main stack name in AEM AWS Stack Builder. | Optional | aem-stack-manager-main-stack |
