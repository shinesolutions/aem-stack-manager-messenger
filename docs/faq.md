Frequently Asked Questions
--------------------------

* __Q:__ How to add a new Stack Manager event?<br/>
  __A:__ Follow the steps below:<br/>
    1. Add a new [Makefile](https://github.com/shinesolutions/aem-stack-manager-messenger/blob/master/Makefile) target for the event
    2. Add a new [message file](https://github.com/shinesolutions/aem-stack-manager-messenger/tree/master/files) for the event
    3. If the event requires a special set of steps, then add a new [Ansible playbook](https://github.com/shinesolutions/aem-stack-manager-messenger/tree/master/ansible/playbooks), otherwise use the existing `send-message` playbook
    4. Add the event to [Stack Manager config, CloudFormation, and SSM commands](https://github.com/shinesolutions/aem-aws-stack-builder/commit/0fab6590ce13099271dffaf3e8e05c4289980a95) in AEM AWS Stack Builder
    5. Update the [README](https://github.com/shinesolutions/aem-stack-manager-messenger/blob/master/README.md) file with example usage command for the event

* __Q:__ Where can I find the Run Command status for the Stack Manager event?<br/>
  __A:__ On AWS console, go to EC2 service, Run Command section, and use the filter to find the status.
  
* __Q:__ Where can I find the CloudWatch logs for the Stack Manager event?<br/>
  __A:__ On AWS console, go to CloudWatch service, Logs section, and find the log group `/aws/lambda/<stack_prefix>-stack-manager-<ssm_command>`.

* __Q:__ Where can I find the log files for the SSM commands execution on the EC2 instance?<br/>
  __A:__ You can find `stdout` and `stderr` log files at `/var/lib/amazon/ssm/<instance_id>/document/orchestration/<execution_id>/` .
