version ?= 1.3.1

# development targets

ci: clean deps lint package

clean:
	rm -rf logs
	rm -f *.retry

deps:
	pip install -r requirements.txt

lint:
	shellcheck scripts/*.sh test/integration/*.sh
	ANSIBLE_LIBRARY=ansible/library/ \
	  ansible-playbook \
    ansible/playbooks/*.yaml \
		-v \
		--syntax-check

# Stack Manager event targets

deploy-artifact:
	./scripts/run-playbook.sh send-message deploy-artifact "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "component=$(component) aem_id=$(aem_id) source=$(source) group=$(group) name=$(name) version=$(version) replicate=$(replicate) activate=$(activate) force=$(force)"

deploy-artifacts-consolidated:
	./scripts/run-playbook.sh send-message deploy-artifacts-consolidated "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "descriptor_file=$(descriptor_file)"

deploy-artifacts-full-set:
	./scripts/run-playbook.sh send-message deploy-artifacts-full-set "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "descriptor_file=$(descriptor_file)"

disable-crxde:
	./scripts/run-playbook.sh send-message disable-crxde "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "component=$(component)"

list-packages:
	./scripts/run-playbook.sh send-message list-packages "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "component=$(component)"

export-package:
	./scripts/run-playbook.sh send-message export-package "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "component=$(component) aem_id=$(aem_id) package_group=$(package_group) package_name=$(package_name) package_filter=$(package_filter)"

export-packages-consolidated:
	./scripts/run-playbook.sh send-message export-packages-consolidated "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "descriptor_file=$(descriptor_file)"

export-packages-full-set:
	./scripts/run-playbook.sh send-message export-packages-full-set "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "descriptor_file=$(descriptor_file)"

enable-crxde:
	./scripts/run-playbook.sh send-message enable-crxde "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "component=$(component)"

flush-dispatcher-cache:
	./scripts/run-playbook.sh send-message flush-dispatcher-cache "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "component=$(component)"

import-package:
	./scripts/run-playbook.sh send-message import-package "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "component=$(component) aem_id=$(aem_id) source_stack_prefix=$(source_stack_prefix) package_group=$(package_group) package_name=$(package_name) package_datestamp=$(package_datestamp)"

live-snapshot:
	./scripts/run-playbook.sh send-message live-snapshot "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "component=$(component)"

offline-compaction-snapshot:
	./scripts/run-playbook.sh offline-compaction-snapshot offline-compaction-snapshot "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)"

offline-snapshot:
	./scripts/run-playbook.sh offline-snapshot offline-snapshot "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)"

promote-author:
	./scripts/run-playbook.sh send-message promote-author "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)"

run-adhoc-puppet:
	./scripts/run-playbook.sh send-message run-adhoc-puppet "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "component=$(component) puppet_tar_file=$(puppet_tar_file)"

check-readiness-consolidated:
	./scripts/run-playbook.sh send-message test-readiness-consolidated "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)"

check-readiness-full-set:
	# TODO: remove this temporary delay until provisioning readiness is checked
	# this is part of https://github.com/shinesolutions/aem-stack-manager-messenger/issues/45
	sleep 120
	./scripts/run-playbook.sh send-message test-readiness-full-set "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)"

schedule-offline-snapshot-full-set:
	./scripts/run-playbook.sh send-message schedule-job-full-set "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "schedule_job=offline_snapshot"

unschedule-offline-snapshot-full-set:
	./scripts/run-playbook.sh send-message unschedule-job-full-set "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "schedule_job=offline_snapshot"

schedule-offline-compaction-snapshot-full-set:
	./scripts/run-playbook.sh send-message schedule-job-full-set "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "schedule_job=offline_compaction_snapshot"

unschedule-offline-compaction-snapshot-full-set:
	./scripts/run-playbook.sh send-message unschedule-job-full-set "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "schedule_job=offline_compaction_snapshot"

schedule-offline-snapshot-consolidated:
	./scripts/run-playbook.sh send-message schedule-job-consolidated "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "schedule_job=offline_snapshot"

unschedule-offline-snapshot-consolidated:
	./scripts/run-playbook.sh send-message unschedule-job-consolidated "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "schedule_job=offline_snapshot"

schedule-offline-compaction-snapshot-consolidated:
	./scripts/run-playbook.sh send-message schedule-job-consolidated "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "schedule_job=offline_compaction_snapshot"

unschedule-offline-compaction-snapshot-consolidated:
	./scripts/run-playbook.sh send-message unschedule-job-consolidated "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "schedule_job=offline_compaction_snapshot"

# Integration test targets

test-consolidated:
	test/integration/all-events-consolidated.sh "$(stack_prefix)" "$(target_aem_stack_prefix)"

test-full-set:
	test/integration/all-events-full-set.sh "$(stack_prefix)" "$(target_aem_stack_prefix)"

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
