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
make deploy-artifacts \
    stack_prefix=stack1 \
    config_path=ansible/inventory/group_vars/all.yaml \
    descriptor_file=deploy_descriptor_file.json

```

```
make deploy-artifacts \
    stack_prefix=stack1-cons \
    config_path=ansible/inventory/group_vars/all.yaml \
    descriptor_file=deploy_descriptor_file_cons.json
```

```
make deploy-artifact \
    stack_prefix=stack1 \
    config_path=ansible/inventory/group_vars/all.yaml \
    component=author-primary \
    source=s3://s3bucket/path/aem-helloworld-content-0.0.1-SNAPSHOT.zip \
    group=shinesolutions \
    name=aem-helloworld-content \
    version=0.0.1 \
    replicate=true \
    activate=false \
    force=true
```

```
make disable-crxde \
    stack_prefix=stack1 \
    config_path=ansible/inventory/group_vars/all.yaml \
    component=author-primary \
```

```
make enable-crxde \
    stack_prefix=stack1 \
    config_path=ansible/inventory/group_vars/all.yaml \
    component=author-primary \
```

```
make export-package \
    stack_prefix=stack1 \
    config_path=ansible/inventory/group_vars/all.yaml \
    component=author-primary \
    package_group=somegroup \
    package_name=somepackage \
    package_filter='[{"root":"/apps/geometrixx","rules":[]},{"root":"/apps/geometrixx-common","rules":[]}]'
```

```
make export-packages \
    stack_prefix=stack1 \
    config_path=ansible/inventory/group_vars/all.yaml \
    descriptor_file=descriptor_file.json \   
```

```
make export-packages \
    stack_prefix=stack1-cons \
    config_path=ansible/inventory/group_vars/all.yaml \
    descriptor_file=descriptor_file-cons.json \   
```

```
make flush-dispatcher-cache \
    stack_prefix=stack1 \
    config_path=ansible/inventory/group_vars/all.yaml \
    component=publish-dispatcher \
```

```
make live-snapshot \
    stack_prefix=stack1 \
    config_path=ansible/inventory/group_vars/all.yaml \
    component=author-primary \
```

```
make import-package \
    stack_prefix=stack1 \
    config_path=ansible/inventory/group_vars/all.yaml \
    component=author-primary \
    source_stack_prefix=stack2 \
    package_group=somegroup \
    package_name=somepackage \
    package_datestamp=201702
```

```
make promote-author \
    stack_prefix=stack1 \
    config_path=ansible/inventory/group_vars/all.yaml

```

```
make offline-snapshot \
    stack_prefix=stack1 \
    config_path=ansible/inventory/group_vars/all.yaml

```

```
make offline-compaction-snapshot \
    stack_prefix=stack1 \
    config_path=ansible/inventory/group_vars/all.yaml

```

```
make test-readiness-full-set \
    stack_prefix=stack1 \
    config_path=ansible/inventory/group_vars/all.yaml

```

```
make test-readiness-consolidated \
    stack_prefix=stack1 \
    config_path=ansible/inventory/group_vars/all.yaml

```

## Development

Requirements:

* Install [ShellCheck](https://github.com/koalaman/shellcheck#user-content-installing)

Check shell scripts, and check Ansible playbooks syntax:
```
make lint
```
