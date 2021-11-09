redis = require('redis')
client = redis.createClient({url: 'redis://redis:6379'})
client.set('foo', 'bar')

// 127.0.0.1:6379> get foo
// "bar"
