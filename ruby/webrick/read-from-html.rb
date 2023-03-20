require 'webrick'

server = WEBrick::HTTPServer.new(
    :Port => 80,
    :SSLEnable => false,
    :DocumentRoot => '/var/www/app'
)

server.mount_proc('/') do |request, response|
    response.content_type = 'text/html; charset=utf-8'
    response.body = File.read('/var/www/app/index.html').sub("HEADER_TEXT", "Hello")
end

trap 'INT' do server.shutdown end

server.start
