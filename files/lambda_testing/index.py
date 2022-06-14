"""Return health."""
import logging
import os
import json
import requests
logging.basicConfig()
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def handler(event, context):
    response = requests.get(os.environ['APIGATEWAY_URL'])
    logger.info("APIGATEWAY_URL: " + os.environ['APIGATEWAY_URL'])
    return {
        'statusCode': response.status_code,
        'body': json.dumps(response.json())
    }