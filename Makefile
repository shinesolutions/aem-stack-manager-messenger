version ?= 1.3.0

# development targets

ci: clean deps lint package

clean:
	rm -rf logs
	rm -f *.retry

deps:
	pip install -r requirements.txt

lint:
	shellcheck scripts/*.sh
	ANSIBLE_LIBRARY=ansible/library/ \
	  ansible-playbook \
    ansible/playbooks/*.yaml \
		-v \
		--syntax-check

# send message targets

deploy-artifact:
	./scripts/send-message.sh deploy-artifact "$(stack_prefix)" "$(config_path)" "component=$(component) aem_id=$(aem_id) source=$(source) group=$(group) name=$(name) version=$(version) replicate=$(replicate) activate=$(activate) force=$(force)"

deploy-artifacts-consolidated:
	./scripts/send-message.sh deploy-artifacts-consolidated "$(stack_prefix)" "$(config_path)" "descriptor_file=$(descriptor_file)"

deploy-artifacts-full-set:
	./scripts/send-message.sh deploy-artifacts-full-set "$(stack_prefix)" "$(config_path)" "descriptor_file=$(descriptor_file)"

disable-crxde:
	./scripts/send-message.sh disable-crxde "$(stack_prefix)" "$(config_path)" "component=$(component)"

export-package:
		./scripts/send-message.sh export-package "$(stack_prefix)" "$(config_path)" "component=$(component) aem_id=$(aem_id) package_group=$(package_group) package_name=$(package_name) package_filter=$(package_filter)"

export-packages-consolidated:
	./scripts/send-message.sh export-packages-consolidated "$(stack_prefix)" "$(config_path)" "descriptor_file=$(descriptor_file)"

export-packages-full-set:
	./scripts/send-message.sh export-packages-full-set "$(stack_prefix)" "$(config_path)" "descriptor_file=$(descriptor_file)"

enable-crxde:
	./scripts/send-message.sh enable-crxde "$(stack_prefix)" "$(config_path)" "component=$(component)"

flush-dispatcher-cache:
	./scripts/send-message.sh flush-dispatcher-cache "$(stack_prefix)" "$(config_path)" "component=$(component)"

import-package:
	./scripts/send-message.sh import-package "$(stack_prefix)" "$(config_path)" "component=$(component) aem_id=$(aem_id) source_stack_prefix=$(source_stack_prefix) package_group=$(package_group) package_name=$(package_name) package_datestamp=$(package_datestamp)"

live-snapshot:
	./scripts/send-message.sh live-snapshot "$(stack_prefix)" "$(config_path)" "component=$(component)"

offline-compaction-snapshot:
	./scripts/offline-compaction-snapshot.sh "$(stack_prefix)" "$(config_path)"

offline-snapshot:
	./scripts/offline-snapshot.sh "$(stack_prefix)" "$(config_path)"

promote-author:
	./scripts/send-message.sh promote-author "$(stack_prefix)" "$(config_path)"

run-adhoc-puppet:
	./scripts/send-message.sh run-adhoc-puppet "$(stack_prefix)" "$(config_path)" "component=$(component) puppet_tar_file=$(puppet_tar_file)"

test-readiness-consolidated:
	./scripts/send-message.sh test-readiness-consolidated "$(stack_prefix)" "$(config_path)"

test-readiness-full-set:
	./scripts/send-message.sh test-readiness-full-set "$(stack_prefix)" "$(config_path)"

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
