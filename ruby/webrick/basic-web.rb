require 'webrick'

server = WEBrick::HTTPServer.new(
    :Port => 80,
    :SSLEnable => false,
    :DocumentRoot => '/var/www/app',
    :ServerAlias => 'localhost'
)

server.mount_proc '/' do |req, res|
  res.body = 'Hello, World!'
end

trap 'INT' do server.shutdown end

server.start
