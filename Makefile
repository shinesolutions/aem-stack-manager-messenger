version ?= 2.8.0-pre.0

ci: clean deps lint package

clean:
	rm -rf logs
	rm -f provisioners/ansible/playbooks/*.retry

stage:
	mkdir -p stage/ stage/user-config/ stage/user-descriptors/

package: stage
	tar \
	    --exclude='.git*' \
	    --exclude='.tmp*' \
	    --exclude='.yamllint' \
	    --exclude='stage*' \
	    --exclude='.idea*' \
	    --exclude='.DS_Store*' \
	    --exclude='logs*' \
	    --exclude='*.retry' \
	    --exclude='*.iml' \
	    -czf \
	    stage/aem-stack-manager-messenger-$(version).tar.gz .

release:
	rtk release

################################################################################
# Dependencies resolution targets.
# For deps-test-local targets, the local dependencies must be available on the
# same directory level where aem-stack-manager-messenger is at. The idea is
# that you can test AEM Stack Manager Messenger while also developing those
# dependencies locally.
################################################################################

# resolve dependencies from remote artifact registries
deps:
	pip install -r requirements.txt

# resolve test dependencies from remote artifact registries
deps-test: stage
	rm -rf stage/aem-helloworld-config/ stage/user-config/* stage/*.tar.gz
	wget "https://github.com/shinesolutions/aem-helloworld-config/archive/master.tar.gz" \
	  -O stage/aem-helloworld-config.tar.gz
	cd stage && tar -xvzf aem-helloworld-config.tar.gz && mv aem-helloworld-config-master aem-helloworld-config
	cp -R stage/aem-helloworld-config/aem-stack-manager-messenger/* stage/user-config/
	cp -R stage/aem-helloworld-config/descriptors/* stage/user-descriptors/

# resolve test dependencies from local directories
deps-test-local: stage
	rm -rf stage/aem-helloworld-config/ stage/user-config/*
	cp -R ../aem-helloworld-config/aem-stack-manager-messenger/* stage/user-config/
	cp -R stage/aem-helloworld-config/descriptors/* stage/user-descriptors/

################################################################################
# Code styling check and validation targets:
# - lint Ansible inventory files, Ansible playbooks, tools configuration files
# - lint custom Ansible modules
# - check shell scripts
################################################################################

lint:
	yamllint conf/ansible/inventory/group_vars/*.yaml provisioners/ansible/playbooks/*.yaml .*.yml
	# pylint provisioners/ansible/library/*.py
	shellcheck scripts/*.sh test/integration/*.sh
	ANSIBLE_LIBRARY=provisioners/ansible/library/ \
	  ansible-playbook \
    provisioners/ansible/playbooks/*.yaml \
		-v \
		--syntax-check

################################################################################
# AEM Stack Manager events targets.
# Architecture specific targets have `-consolidated` or `-full-set` suffix.
################################################################################

# deploy a single AEM package artifact
deploy-artifact:
	./scripts/run-playbook.sh send-message deploy-artifact "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "component=$(component) aem_id=$(aem_id) source=$(source) group=$(group) name=$(name) version=$(version) replicate=$(replicate) activate=$(activate) force=$(force)"

# deploy multiple AEM package and Dispatcher config artifacts to an AEM Consolidated environment
deploy-artifacts-consolidated:
	./scripts/run-playbook.sh send-message deploy-artifacts-consolidated "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "descriptor_file=$(descriptor_file)"

# deploy multiple AEM package and Dispatcher config artifacts to an AEM Consolidated environment
deploy-artifacts-full-set:
	./scripts/run-playbook.sh send-message deploy-artifacts-full-set "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "descriptor_file=$(descriptor_file)"

disable-crxde:
	./scripts/run-playbook.sh send-message disable-crxde "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "component=$(component)"

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

list-packages:
	./scripts/run-playbook.sh send-message list-packages "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "component=$(component)"

live-snapshot:
	./scripts/run-playbook.sh send-message live-snapshot "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "component=$(component)"

# an alias to offline-snapshot-full-set
# this is retained for backward compatibility for AEM Stack Manager Messenger 1.4.1 and older
offline-snapshot: offline-snapshot-full-set

# an alias to offline-compaction-snapshot-full-set
# this is retained for backward compatibility for AEM Stack Manager Messenger 1.4.1 and older
offline-compaction-snapshot: offline-compaction-snapshot-full-set

offline-snapshot-full-set:
	./scripts/run-playbook.sh offline-snapshot-full-set offline-snapshot-full-set "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)"

offline-compaction-snapshot-full-set:
	./scripts/run-playbook.sh offline-compaction-snapshot-full-set offline-compaction-snapshot-full-set "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)"

offline-snapshot-consolidated:
	./scripts/run-playbook.sh send-message offline-snapshot-consolidated "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)"

offline-compaction-snapshot-consolidated:
	./scripts/run-playbook.sh send-message offline-compaction-snapshot-consolidated "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)"

promote-author:
	./scripts/run-playbook.sh send-message promote-author "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)"

run-adhoc-puppet:
	./scripts/run-playbook.sh send-message run-adhoc-puppet "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "component=$(component) puppet_tar_file=$(puppet_tar_file)"

check-readiness-consolidated:
	./scripts/run-playbook.sh send-message test-readiness-consolidated "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)"

check-readiness-full-set:
	./scripts/run-playbook.sh send-message test-readiness-full-set "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)"

schedule-offline-snapshot-full-set:
	./scripts/run-playbook.sh send-message schedule-offline-snapshot-job-full-set "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "schedule_job=offline_snapshot"

unschedule-offline-snapshot-full-set:
	./scripts/run-playbook.sh send-message unschedule-offline-snapshot-job-full-set "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "schedule_job=offline_snapshot"

schedule-offline-compaction-snapshot-full-set:
	./scripts/run-playbook.sh send-message schedule-offline-snapshot-job-full-set "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "schedule_job=offline_compaction_snapshot"

unschedule-offline-compaction-snapshot-full-set:
	./scripts/run-playbook.sh send-message unschedule-offline-snapshot-job-full-set "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "schedule_job=offline_compaction_snapshot"

schedule-live-snapshot-full-set:
	./scripts/run-playbook.sh send-message schedule-live-snapshot-job-full-set "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "component=$(component) schedule_job=live_snapshot"

unschedule-live-snapshot-full-set:
	./scripts/run-playbook.sh send-message unschedule-live-snapshot-job-full-set "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "component=$(component) schedule_job=live_snapshot"

schedule-offline-snapshot-consolidated:
	./scripts/run-playbook.sh send-message schedule-offline-snapshot-job-consolidated "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "schedule_job=offline_snapshot"

unschedule-offline-snapshot-consolidated:
	./scripts/run-playbook.sh send-message unschedule-offline-snapshot-job-consolidated "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "schedule_job=offline_snapshot"

schedule-offline-compaction-snapshot-consolidated:
	./scripts/run-playbook.sh send-message schedule-offline-snapshot-job-consolidated "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "schedule_job=offline_compaction_snapshot"

unschedule-offline-compaction-snapshot-consolidated:
	./scripts/run-playbook.sh send-message unschedule-offline-snapshot-job-consolidated "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "schedule_job=offline_compaction_snapshot"

schedule-live-snapshot-consolidated:
	./scripts/run-playbook.sh send-message schedule-live-snapshot-job-consolidated "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "schedule_job=live_snapshot"

unschedule-live-snapshot-consolidated:
	./scripts/run-playbook.sh send-message unschedule-live-snapshot-job-consolidated "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "schedule_job=live_snapshot"

install-aem-profile:
	./scripts/run-playbook.sh send-message install-aem-profile "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "component=$(component) aem_profile=$(aem_profile) aem_artifacts_base=$(aem_artifacts_base) aem_base=$(aem_base) aem_healthcheck_version=$(aem_healthcheck_version) aem_id=$(aem_id) aem_port=$(aem_port) aem_ssl_port=$(aem_ssl_port)"

run-aem-upgrade:
	./scripts/run-playbook.sh send-message run-aem-upgrade "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "component=$(component) aem_upgrade_version=$(aem_upgrade_version)"

upgrade-unpack-jar:
	./scripts/run-playbook.sh send-message upgrade-unpack-jar "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "component=$(component) aem_artifacts_base=$(aem_artifacts_base) aem_upgrade_version=$(aem_upgrade_version) enable_backup=$(enable_backup)"

upgrade-repository-migration:
	./scripts/run-playbook.sh send-message upgrade-repository-migration "$(stack_prefix)" "$(target_aem_stack_prefix)" "$(config_path)" "component=$(component) source_crx2oak=$(source_crx2oak)"

################################################################################
# Integration test targets.
# The targets will execute all AEM Stack Manager events available for each AEM architecture.
################################################################################

test-consolidated: deps deps-test
	test/integration/all-events-consolidated.sh "$(stack_prefix)" "$(target_aem_stack_prefix)"

test-full-set: deps deps-test
	test/integration/all-events-full-set.sh "$(stack_prefix)" "$(target_aem_stack_prefix)"

test-consolidated-local: deps deps-test-local
	test/integration/all-events-consolidated.sh "$(stack_prefix)" "$(target_aem_stack_prefix)"

test-full-set-local: deps deps-test-local
	test/integration/all-events-full-set.sh "$(stack_prefix)" "$(target_aem_stack_prefix)"

.PHONY: ci clean stage package deps deps-test deps-test-local lint deploy-artifact deploy-artifacts-consolidated deploy-artifacts-full-set disable-crxde export-package export-packages-consolidated export-packages-full-set enable-crxde flush-dispatcher-cache import-package list-packages live-snapshot offline-snapshot offline-compaction-snapshot offline-snapshot-full-set offline-compaction-snapshot-full-set offline-snapshot-consolidated offline-compaction-snapshot-consolidated promote-author run-adhoc-puppet check-readiness-consolidated check-readiness-full-set schedule-offline-snapshot-full-set unschedule-offline-snapshot-full-set schedule-offline-compaction-snapshot-full-set unschedule-offline-compaction-snapshot-full-set schedule-live-snapshot-full-set unschedule-live-snapshot-full-set schedule-offline-snapshot-consolidated unschedule-offline-snapshot-consolidated schedule-offline-compaction-snapshot-consolidated unschedule-offline-compaction-snapshot-consolidated schedule-live-snapshot-consolidated unschedule-live-snapshot-consolidated install-aem-profile test-consolidated test-full-set test-consolidated-local test-full-set-local release
