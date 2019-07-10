# pip install slackclient
# https://github.com/JPStrydom/Crypto-Trading-Bot/issues/10

from slack import WebClient as SlackClient
legacy_token = "" # https://api.slack.com/custom-integrations/legacy-tokens
slack_client = SlackClient(legacy_token)

def list_channels():
    name_to_id = {}
    res = slack_client.api_call(
        "groups.list", # groups are private channels, conversations are public channels. Different API.
    )
    list_channels = {"private_channels": []}
    for channel in res['groups']:
        list_channels['private_channels'].append({channel['name']: channel['id']})

    return list_channels
