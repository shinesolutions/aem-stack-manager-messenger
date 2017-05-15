version ?= 0.9.0

# development targets

ci: clean deps lint package

clean:
	rm -rf logs
	rm -f *.retry

deps:
	pip install -r requirements.txt

lint:
	shellcheck send-message.sh
	ansible-playbook -vvv send-message.yaml --syntax-check


# send message targets

promote-author:
	./send-message.sh "$(stack_prefix)" "$(topic_config_file)" "$(message_config_file)"


deploy-artifacts:
	./send-message.sh "$(stack_prefix)" "$(topic_config_file)" "$(message_config_file)" "descriptor_file=$(descriptor_file)"


deploy-artifact:
	./send-message.sh "$(stack_prefix)" "$(topic_config_file)" "$(message_config_file)" "component=$(component) \
										 package_source=$(package_source) package_group=$(package_group) package_name=$(package_name) \
										 package_version=$(package_version) replicate=$(replicate) activate=$(activate) force=$(force)"

export-package:
	echo package_filter=$(package_filter)
	./send-message.sh "$(stack_prefix)" "$(topic_config_file)" "$(message_config_file)" "component=$(component) package_group=$(package_group) package_name=$(package_name) package_filter=$(package_filter)"


import-package:
	./send-message.sh "$(stack_prefix)" "$(topic_config_file)" "$(message_config_file)" "component=$(component) package_group=$(package_group) package_name=$(package_name) package_datestamp=$(package_datestamp)"


offline-snapshot:
	./send-message.sh "$(stack_prefix)" "$(topic_config_file)" "$(message_config_file)"


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


.PHONY: promote-author offline-snapshot deploy-artifacts deploy-artifact ci clean deps lint export-package import-package package
