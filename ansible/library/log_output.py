#!/usr/bin/python
# -*- coding: utf8 -*-

ANSIBLE_METADATA = {'metadata_version': '1.1'}
DOCUMENTATION = '''
---
module: log_output
Ansible module for output logfiles of Amazon AWS SSM run_cmd
requirements:
  - python >= 2.6
options:
    type:
        description:
          - Either if input is(are) path(s) or file(s)
        required: true
    log_files:
        description:
          - Input path(s) or file(s). Multiple path(s)/file(s) can be given as a list.
        required: true
'''

EXAMPLES = '''
- name: Show logoutput
  log_output:
    type: file
    log_files: "stderr"
  register: result

- name: Show logoutput
  log_output:
      type: file
      state: info
      log_files: "{{ stderr_files.files | map(attribute='path')|list }}"
'''

import os
import sys
from ansible.module_utils.basic import *

try:
    import json
    HAS_JSON = True
except ImportError:
    HAS_JSON = False

class log_analyse:
    def __init__(self, module):
        self.module = module

    def analyse(self):
        log_type = self.module.params.get("type")
        log_files = self.module.params.get("log_files")
        result = []
        if log_type == 'file':
            i = 0
            instance_id_array = 4
            for files in log_files:
                file_exist = os.path.exists(files)
                if file_exist == True:
                    file_split = files.split('/')
                    instance_id = file_split[len(file_split) - instance_id_array]
                    instance_id.startswith('i-')
                    if instance_id.startswith('i-') == True:
                        try:
                            file_open = open(files, 'r')
                        except Exception as e:
                            self.module.fail_json(msg="Error: Can't open logfile: " + files + " - " + str(e))
                        result.append({ 'instance_id': instance_id,
                        'log_file': files,
                        'log_output': file_open.read()})
                    else:
                        while (instance_id.startswith('i-') == False):
                            i = i + 1
                            instance_id = file_split[len(file_split) - i]
                            if instance_id.startswith('i-') == True:
                                try:
                                    file_open = open(files, 'r')
                                except Exception as e:
                                    self.module.fail_json(msg="Error: Can't open logfile: " + files + " - " + str(e))
                                result.append({ 'instance_id': instance_id,
                                'log_file': files,
                                'log_output': file_open.read()})
                            elif i > 50:
                                self.module.fail_json(msg="Error: Can not determine all Instance-IDs in folder Pathname. Folder name instance-id deeper than 50?")
                else:
                    self.module.fail_json(msg="Error: Log file not found: " + files)

        elif log_type == 'directory':
            self.module.fail_json(msg="Not implemented yet")

        return result

def main():
    argument_spec = {}
    argument_spec.update(dict(
            type=dict(required=True, type='str' ),
            log_files=dict(required=True, type='list'),
    ))
    module = AnsibleModule(argument_spec=argument_spec)

    if module.check_mode:
        return result

    log = log_analyse(module)

    result = log.analyse()

    module.exit_json(changed=True, item=result)

if __name__ == '__main__':
    main()
