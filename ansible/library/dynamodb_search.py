#!/usr/bin/python

ANSIBLE_METADATA = {'metadata_version': '1.1'}


DOCUMENTATION = """
---
module: dynamodb_search
short_description: Scan and query DB Table
version_added: "1.0"
description:
  - Scan DynamoDB Table for given Attribute value.
  - Query DynamoDB with KeyConditions.
requirements:
  - boto3 >= 1.0.0
options:
  state:
    description:
      - Scan or query Database table.
    required: true
    choices: ['scan', 'query']
    default: null
  table_name:
    description:
      - Name of the table.
    required: true
    default: null
  get_attribute:
    description:
      - Name of the Attribute to get from the table.
    required: true
    default: null
  select:
    description:
      - The attributes to be returned in the result.
    required: false
    choices: ['ALL_ATTRIBUTES', 'ALL_PROJECTED_ATTRIBUTES', 'SPECIFIC_ATTRIBUTES', 'COUNT']
    default: 'ALL_ATTRIBUTES'
  attribute:
    description:
      - Name of the Attribute to query/scan the table.
    required: true
    default: null
  attribute_value:
    description:
      - Value of the attribute in the table.
    required: true
    default: null
  comparisonoperator:
    description:
      - Comparison operator for matching the attribute_value with the attribute.
    required: false
    choices: ['EQ', 'NE', 'IN', 'LE', 'LT', 'GE', 'GT', 'BETWEEN', 'NOT_NULL', 'NULL', 'CONTAINS', 'NOT_CONTAINS', 'BEGINS_WITH']
    default: EQ
extends_documentation_fragment:
    - aws
    - ec2
"""

EXAMPLES = '''
# Scan dynamo table for attribute message_id and only return attribute command_id
- dynamodb_search:
    table_name: "michaelb-aem63-AemStackManagerTable"
    attribute: "message_id"
    attribute_value: "123"
    get_attribute: "command_id"
    select: "SPECIFIC_ATTRIBUTES"
    comparisonoperator: "EQ"
    state: scan


# Query dynamo table for KeyConditions command_id and only return attribute state
- dynamodb_search:
    table_name: "michaelb-aem63-AemStackManagerTable"
    attribute: "command_id"
    attribute_value: "456"
    get_attribute: "state"
    select: "SPECIFIC_ATTRIBUTES"
    comparisonoperator: "EQ"
    state: query
'''

RETURN = '''
msg:
    get_attribute: Value.
'''

import traceback

try:
    import botocore
    from ansible.module_utils.ec2 import ansible_dict_to_boto3_tag_list, boto3_conn
    HAS_BOTO = True
except ImportError:
    HAS_BOTO = False

from ansible.module_utils.basic import AnsibleModule
from ansible.module_utils.ec2 import AnsibleAWSError, connect_to_aws, ec2_argument_spec, get_aws_connection_info


def dynamo_table_exists(table, module):
    try:
        table.load()
        return True
    except Exception as e:
        module.fail_json(msg="Error: " + str(e))

def scan(client_connection, resource_connection, module):
    table_name = module.params.get('table_name')
    get_attribute = module.params.get('get_attribute')
    scan_limit = module.params.get('scan_limit')
    select = module.params.get('select')
    attribute = module.params.get('attribute')
    attribute_value = module.params.get('attribute_value')
    comparisonoperator = module.params.get('comparisonoperator')

    try:
        table = resource_connection.Table(table_name)
        if dynamo_table_exists(table, module):
            response = client_connection.scan(
                TableName = table_name,
                AttributesToGet = [
                    get_attribute,
                ],
                Limit = scan_limit,
                Select = select,
                ScanFilter={
                    attribute: {
                        'AttributeValueList': [
                        {'S': attribute_value,}
                        ],
                        'ComparisonOperator': comparisonoperator
                    }
                },
            )
            changed = False
        else:
            module.fail_json("Error: Table not found")

        if get_attribute == 'command_id':
            result = 'command_id\': ' + response['Items'][0]['command_id']['S']
        else:
            result = response
    except Exception as e:
        module.fail_json(msg="Error: " + str(e), exception=traceback.format_exc(e))
    else:
        module.exit_json(changed=changed, msg={result})

def query(client_connection, resource_connection, module):
    table_name = module.params.get('table_name')
    get_attribute = module.params.get('get_attribute')
    scan_limit = module.params.get('scan_limit')
    select = module.params.get('select')
    attribute = module.params.get('attribute')
    attribute_value = module.params.get('attribute_value')
    comparisonoperator = module.params.get('comparisonoperator')

    try:
        table = resource_connection.Table(table_name)
        if dynamo_table_exists(table, module):
            response = client_connection.query(
                TableName = table_name,
                AttributesToGet=[
                    get_attribute,
                ],
                Limit = scan_limit,
                Select = select,
                KeyConditions={
                    attribute: {
                        'AttributeValueList': [
                        {'S': attribute_value,}
                        ],
                    'ComparisonOperator': comparisonoperator
                    }
                },
            )
            changed = False
            result = response['Items']
        else:
            module.fail_json("Error: Table not found")

        if get_attribute == 'message_id':
            result = 'message_id\': ' + result[0]['message_id']['S']
        elif get_attribute == 'state':
            result = 'state\': ' + result[0]['state']['S']

    except Exception as e:
        module.fail_json(msg="Error: Can't execute query - " + str(e), exception=traceback.format_exc(e))
    else:
        module.exit_json(changed=changed, msg={result})

def main():
    argument_spec = ec2_argument_spec()
    argument_spec.update(dict(
        table_name = dict(required=True, type='str'),
        get_attribute = dict(type='str'),
        scan_limit = dict(default=10000, type='int'),
        select = dict(default='ALL_ATTRIBUTES', type='str', choices=['ALL_ATTRIBUTES', 'ALL_PROJECTED_ATTRIBUTES', 'SPECIFIC_ATTRIBUTES', 'COUNT']),
        attribute = dict(type='str'),
        attribute_value = dict(default=[], type='str'),
        comparisonoperator = dict(default='EQ', type='str', choices=['EQ', 'NE', 'IN', 'LE', 'LT', 'GE', 'GT', 'BETWEEN', 'NOT_NULL', 'NULL', 'CONTAINS', 'NOT_CONTAINS', 'BEGINS_WITH']),
        state = dict(required=True, type='str', choices=['scan', 'query']),

    ))

    module = AnsibleModule(argument_spec=argument_spec)

    if not HAS_BOTO:
        module.fail_json(msg='boto3 required for this module')

    region, ec2_url, aws_connect_params = get_aws_connection_info(module, boto3=True)

    if not region:
        module.fail_json(msg='region must be specified')

    try:
        client_connection = boto3_conn(module, conn_type='client',
                resource='dynamodb', region=region,
                endpoint=ec2_url, **aws_connect_params)
        resource_connection = boto3_conn(module, conn_type='resource',
                resource='dynamodb', region=region,
                endpoint=ec2_url, **aws_connect_params)
    except botocore.exceptions.NoCredentialsError as e:
        module.fail_json(msg='cannot connect to AWS', exception=traceback.format_exc(e))

    state = module.params.get("state")

    if state == 'scan':
        scan(client_connection, resource_connection, module)
    elif state == 'query':
        query(client_connection, resource_connection, module)
    else:
        module.fail_json(msg='Error: unsupported state. Supported states are scan and query')

if __name__ == '__main__':
    main()
