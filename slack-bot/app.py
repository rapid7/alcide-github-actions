import os
from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError

token=os.environ['token']
channel=os.environ['channel']
header=os.environ['header']
pre_message=os.environ['pre_message']
message=os.environ['message']
post_message=os.environ['post_message']
actor=os.environ['actor']
release=os.environ['release']
commit_id=os.environ['commit_id']

client = WebClient(token)

try:

    # filepath="./tmp.txt"
    # response = client.files_upload(channels='#random', file=filepath)
    blocks=[
        {
            "type": "header",
            "text": {
                "type": "plain_text",
                "text": header
            }
        },
        {
            "type": "divider"
        },
        {
            "type": "section",
            "text": {
                "text": pre_message,
                "type": "mrkdwn"
            }
        },
        {
            "type": "section",
            "text": {
                "text": message,
                "type": "mrkdwn"
            },
            "fields": [
                {
                    "type": "mrkdwn",
                    "text": "*Release*"
                },
                {
                    "type": "mrkdwn",
                    "text": "*Commit*"
                },
                {
                    "type": "plain_text",
                    "text": release
                },
                {
                    "type": "plain_text",
                    "text": commit_id
                }
            ]
        },
        {
            "type": "section",
            "text": {
                "text": post_message,
                "type": "mrkdwn"
            }
        },
        {
            "type": "section",
            "text": {
                "text": actor,
                "type": "mrkdwn"
            }
        },
    ]

    response = client.chat_postMessage(channel=channel, blocks=blocks)
    # assert response["message"]["text"] == "Hello world!"
except SlackApiError as e:
    # You will get a SlackApiError if "ok" is False
    assert e.response["ok"] is False
    assert e.response["error"]  # str like 'invalid_auth', 'channel_not_found'
    print(f"Got an error: {e.response['error']}")