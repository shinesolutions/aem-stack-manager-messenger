# aem-stack-manager-messenger
Send messages to AEM Stack Manager via SNS Topic

Uses the Ansible sns module: http://docs.ansible.com/ansible/sns_module.html to send messages.


## Installation


Requirements:

* Run `make deps` to install [AWS CLI](http://docs.aws.amazon.com/cli/latest/userguide/installing.html), [Ansible](http://docs.ansible.com/ansible/intro_installation.html), and [Boto 3](https://boto3.readthedocs.io/en/latest/).
* [Configure](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html#cli-quick-configuration) AWS CLI.



## Configuration

Create yourself a configuration file (yaml). Containing the region and the topic to send the messages to.

Example:

topic-config.yaml:

```
aws_region: ap-southeast-2
sns_topic: aem-stack-manager-topic
```


## Usage

Use the send-message make targets, passing in parameters for each message and the configuration files.


```
make promote-author \
    stack_prefix=stack1 \
    topic_config_file=inventory/group_vars/all.yaml \
    message_config_file=inventory/group_vars/promote-author.yaml

```

```
make deploy-artifacts \
    stack_prefix=stack1 \
    topic_config_file=inventory/group_vars/all.yaml \
    message_config_file=inventory/group_vars/deploy-artifacts.yaml \
    descriptor_file=abc

```

```
make deploy-artifact \
    stack_prefix=stack1 \
    topic_config_file=inventory/group_vars/all.yaml \
    message_config_file=inventory/group_vars/deploy-artifact.yaml \
    component=author-primary \
    artifact=xyz
```



```
make export-package \
    stack_prefix=stack1 \
    topic_config_file=inventory/group_vars/all.yaml \
    message_config_file=inventory/group_vars/export-package.yaml \
    component=author-primary \
    package_group=somegroup \
    package_name=somepackage \
    package_filter='[{"root":"/apps/geometrixx","rules":[]},{"root":"/apps/geometrixx-common","rules":[]}]'
```


```
make import-package \
    stack_prefix=stack1 \
    topic_config_file=inventory/group_vars/all.yaml \
    message_config_file=inventory/group_vars/import-package.yaml \
    component=author-primary \
    source_stack_prefix=stack2 \
    package_group=somegroup \
    package_name=somepackage \
    package_datestamp=201702
```

```
make offline-snapshot \
    stack_prefix=stack1 \
    topic_config_file=inventory/group_vars/all.yaml \
    message_config_file=inventory/group_vars/offline-snapshot.yaml

```

## Development

Requirements:

* Install [ShellCheck](https://github.com/koalaman/shellcheck#user-content-installing)

Check shell scripts, and check Ansible playbooks syntax:
```
make lint
```
