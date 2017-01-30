
# development targets

ci: clean deps lint

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
	./send-message.sh "$(stack_prefix)" "$(topic_config_file)" "$(message_config_file)" "component=$(component) artifact=$(artifact)"


.PHONY: promote-author deploy-artifacts deploy-artifact ci clean deps lint
