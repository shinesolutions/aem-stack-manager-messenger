Configuration
-------------

The following configurations are available for users to customise Stack Manager event processing.

Check out the [example configuration files](https://github.com/shinesolutions/aem-stack-manager-messenger/blob/master/examples/user-config/) as reference.

| Name | Description | Default |
|------|-------------|---------|
| show_log_on_failure_only | If set to true, log will only be displayed when there is a failure. If set to false, all logs will displayed regardless of success or failure | true |
| poll_timeout.check_message_sent.retries | The number of times it will check whether message payload has been sent | 120 |
| poll_timeout.check_message_sent.delay | The duration (in seconds) between message sent checks | 5 |
| poll_timeout.check_command_execution.retries | The number of times it will check the status of command execution until there is a success or a failure | 120 |
| poll_timeout.check_command_execution.delay | The duration (in seconds) between command execution checks | 5 |
| main.stack_name | The Stack Manager's main stack name. You need to overwrite this only when you customise the Stack Manager's main stack name in AEM AWS Stack Builder | aem-stack-manager-main-stack |
