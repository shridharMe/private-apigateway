import os
import json
def handler(event, context):
    runtime_region = os.environ['AWS_REGION']
    return {
        'statusCode': 200,
        'body': json.dumps( 'This Lambda Function was run in region: '+runtime_region)
    }
