require 'webrick'
require 'json'

class MyApi < WEBrick::HTTPServlet::AbstractServlet
  def do_GET(request, response)
    # Handle GET request
    response.status = 200
    response['Content-Type'] = 'application/json'
    response.body = '{"message": "Hello, World!"}'
  end

  def do_POST(request, response)
    # Handle POST request
    request_body = JSON.parse(request.body)
    response.status = 200
    response['Content-Type'] = 'application/json'
    response.body = '{"message": "Received POST request with data: ' + request_body.to_s + '"}'
  end

  def do_PUT(request, response)
    # Handle PUT request
    request_body = JSON.parse(request.body)
    response.status = 200
    response['Content-Type'] = 'application/json'
    response.body = '{"message": "Received PUT request with data: ' + request_body.to_s + '"}'
  end

  def do_DELETE(request, response)
    # Handle DELETE request
    response.status = 200
    response['Content-Type'] = 'application/json'
    response.body = '{"message": "Received DELETE request"}'
  end

end

server = WEBrick::HTTPServer.new(Port: 8080)
server.mount '/api', MyApi
trap('INT') { server.shutdown }
server.start
