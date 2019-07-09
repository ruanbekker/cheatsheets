import boto3
import time
import random
import datetime

client = boto3.Session(region_name='eu-west-1').client('dynamodb', aws_access_key_id='', aws_secret_access_key='', endpoint_url='http://localhost:4567')

userlists = {}
userlists['john'] = {'id':'johnsnow9801', 'firstname': 'john', 'age': '23', 'location': 'south africa', 'rank': 'professional'}
userlists['max'] = {'id':'maxmilia', 'firstname': 'max', 'age': '24', 'location': 'new zealand', 'rank': 'professional'}
userlists['samantha'] = {'id':'sambubbles8343', 'firstname': 'samantha', 'age': '21', 'location': 'australia', 'rank': 'professional'}
userlists['aubrey'] = {'id':'aubreyxeleven4712', 'firstname': 'aubrey', 'age': '24', 'location': 'america', 'rank': 'professional'}
userlists['mikhayla'] = {'id':'mikkie1419', 'firstname': 'mikhayla', 'age': '21', 'location': 'mexico', 'rank': 'professional'}
userlists['steve'] = {'id':'stevie1119', 'firstname': 'steve', 'age': '25', 'location': 'ireland', 'rank': 'professional'}
userlists['rick'] = {'id':'rickmax0901', 'firstname': 'rick', 'age': '20', 'location': 'sweden', 'rank': 'professional'}
userlists['michael'] = {'id':'mikeshank2849', 'firstname': 'michael', 'age': '26', 'location': 'america', 'rank': 'professional'}
userlists['paul'] = {'id':'paulgru2039', 'firstname': 'paul', 'age': '26', 'location': 'sweden', 'rank': 'professional'}
userlists['nathalie'] = {'id':'natscotia2309', 'firstname': 'nathalie', 'age': '21', 'location': 'america', 'rank': 'professional'}
userlists['scott'] = {'id':'scottie2379', 'firstname': 'scott', 'age': '23', 'location': 'new zealand', 'rank': 'professional'}
userlists['will'] = {'id':'wilson9335', 'firstname': 'will', 'age': '27', 'location': 'sweden', 'rank': 'professional'}
userlists['adrian'] = {'id':'adriano5519', 'firstname': 'adrian', 'age': '22', 'location': 'ireland', 'rank': 'professional'}
userlists['julian'] = {'id':'jules8756', 'firstname': 'julian', 'age': '27', 'location': 'mexico', 'rank': 'professional'}
userlists['rico'] = {'id':'ricololo4981', 'firstname': 'rico', 'age': '20', 'location': 'sweden', 'rank': 'professional'}
userlists['kate'] = {'id':'kitkatkate0189', 'firstname': 'kate', 'age': '24', 'location': 'south africa', 'rank': 'professional'}

events = []
events = [
	{
		'name': 'gaming_nationals_round_01',
		'game': 'counter_strike'
	},
	{
		'name': 'gaming_nationals_round_02',
		'game': 'fifa'
	},
	{
		'name': 'gaming_nationals_round_03',
		'game': 'rocket_league'
	},
	{
		'name': 'gaming_nationals_round_04',
		'game': 'world_of_warcraft'
	},
	{
		'name': 'gaming_nationals_round_05',
		'game': 'pubg'
	},
	{
		'name': 'gaming_nationals_round_06',
		'game': 'league_of_legends'
	},
	{
		'name': 'gaming_nationals_round_07',
		'game': 'dota'
	}
]

users = userlists.keys()

def generate(name, eventname):
    item = {
        'event': {'S': eventname['name']},
        'timestamp': {'S': datetime.datetime.utcnow().strftime("%Y-%m-%dT%H:%M")},
        'gamerid': {'S': name['id']},
        'name': {'S': name['firstname']},
        'age': {'N': str(name['age'])},
        'location': {'S': name['location']},
        'game': {'S': eventname['game']},
        'score': {'N': str(random.randint(10000, 19999))},
        'rank': {'S': name['rank']}}
    return item

for eventname in events:
    for user in users:
        item = generate(userlists[user], eventname)
        print("Event: {} - submitting scores to dynamodb for {}".format(item['event']['S'], user))
        response = client.put_item(TableName='gamescores', Item=item)
    time.sleep(300)
    print("")

print("done")
