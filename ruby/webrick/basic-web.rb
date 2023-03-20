require 'webrick'

server = WEBrick::HTTPServer.new(
    :Port => 80,
    :SSLEnable => false,
    :DocumentRoot => '/var/www/app',
    :ServerAlias => 'localhost'
)

server.mount_proc '/' do |request, response|
  response.status = 200
  response.content_type = 'text/html; charset=utf-8'
  response.body = 'Hello, World!'
end

trap 'INT' do server.shutdown end

server.start
