version ?= 1.2.3

# development targets

ci: clean deps lint package

clean:
	rm -rf logs
	rm -f *.retry

deps:
	pip install -r requirements.txt

lint:
	shellcheck scripts/*.sh
	ansible-playbook -vvv ansible/playbooks/*.yaml --syntax-check


# send message targets

promote-author:
	./scripts/send-message.sh "$(stack_prefix)" "$(topic_config_file)" "$(message_config_file)"

deploy-artifacts:
	./scripts/send-message.sh "$(stack_prefix)" "$(topic_config_file)" "$(message_config_file)" "descriptor_file=$(descriptor_file)"

deploy-artifact:
	./scripts/send-message.sh "$(stack_prefix)" "$(topic_config_file)" "$(message_config_file)" "component=$(component) source=$(source) group=$(group) name=$(name) version=$(version) replicate=$(replicate) activate=$(activate) force=$(force)"

export-package:
	echo package_filter=$(package_filter)
	./scripts/send-message.sh "$(stack_prefix)" "$(topic_config_file)" "$(message_config_file)" "component=$(component) package_group=$(package_group) package_name=$(package_name) package_filter=$(package_filter)"

export-packages:
	echo descriptor_file=$(descriptor_file)
	./scripts/send-message.sh "$(stack_prefix)" "$(topic_config_file)" "$(message_config_file)" "descriptor_file=$(descriptor_file)"

enable-crxde:
	./scripts/send-message.sh "$(stack_prefix)" "$(topic_config_file)" "$(message_config_file)" "component=$(component)"

disable-crxde:
	./scripts/send-message.sh "$(stack_prefix)" "$(topic_config_file)" "$(message_config_file)" "component=$(component)"

flush-dispatcher-cache:
	./scripts/send-message.sh "$(stack_prefix)" "$(topic_config_file)" "$(message_config_file)" "component=$(component)"

live-snapshot:
	./scripts/send-message.sh "$(stack_prefix)" "$(topic_config_file)" "$(message_config_file)" "component=$(component)"

import-package:
	./scripts/send-message.sh "$(stack_prefix)" "$(topic_config_file)" "$(message_config_file)" "component=$(component) source_stack_prefix=$(source_stack_prefix) package_group=$(package_group) package_name=$(package_name) package_datestamp=$(package_datestamp)"

offline-snapshot:
	./scripts/offline-snapshot.sh "$(stack_prefix)" "$(topic_config_file)" "$(message_config_file)"

offline-compaction-snapshot:
	./scripts/offline-compaction-snapshot.sh "$(stack_prefix)" "$(topic_config_file)" "$(message_config_file)"

run-adhoc-puppet:
	./scripts/send-message.sh "$(stack_prefix)" "$(topic_config_file)" "$(message_config_file)" "component=$(component) puppet_tar_file=$(puppet_tar_file)"

test-readiness-full-set:
	./scripts/send-message.sh "$(stack_prefix)" "$(topic_config_file)" "$(message_config_file)"

test-readiness-consolidated:
	./scripts/send-message.sh "$(stack_prefix)" "$(topic_config_file)" "$(message_config_file)"

package:
	rm -rf stage
	mkdir -p stage
	tar \
	    --exclude='.git*' \
	    --exclude='.tmp*' \
	    --exclude='stage*' \
	    --exclude='.idea*' \
	    --exclude='.DS_Store*' \
	    --exclude='logs*' \
	    --exclude='*.retry' \
	    --exclude='*.iml' \
	    -cvf \
	    stage/aem-stack-manager-messenger-$(version).tar ./
	gzip stage/aem-stack-manager-messenger-$(version).tar

git-archive:
	rm -rf stage
	mkdir -p stage
	git archive --format=tar.gz --prefix=aem-stack-manager-messenger-$(version)/ HEAD -o stage/aem-stack-manager-messenger-$(version).tar.gz

.PHONY: promote-author offline-snapshot deploy-artifacts deploy-artifact ci clean deps lint export-package import-package package git-archive offline-compaction-snapshot
