"""Return health."""
import logging
import os
import json
logging.basicConfig()
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def handler(event, context):
    """Lambda handler for getting the health."""

    logger.info("status: " + os.environ['STATUS'])
    return {
        'statusCode': 200,
        'body': json.dumps( 'HealthCheck status: '+ os.environ['STATUS'])
    }