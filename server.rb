# server.rb

require 'socket'
require 'pry'

def parse_request(request_line)
  url_components = request_line.split(/[ ?]/)

  http_method = url_components[0]
  path = url_components[1]
  params = url_components[2].split('&').map do |param|
    param.split('=')
  end.to_h

  [http_method, path, params]
end

server = TCPServer.new('localhost', 3003)
loop do
  client = server.accept

  request_line = client.gets
  next if !request_line || request_line =~ /favicon/

  http_method, path, params = parse_request(request_line)
  rolls = params['rolls'].to_i
  sides = params['sides'].to_i

  # output to console
  puts request_line
  puts http_method
  puts path
  puts params

  # server response
  client.puts "HTTP/1.1 200 OK"
  client.puts "Content-Type: text/html"
  client.puts
  client.puts '<html>'
  client.puts '<body>'
  client.puts '<pre>'
  client.puts http_method
  client.puts path
  client.puts params
  client.puts
  client.puts "<a href='?rolls=2&sides=6'>Roll 2d6</a>"
  client.puts "<a href='?rolls=1&sides=6'>Roll 1d4</a>"
  client.puts "<a href='?rolls=3&sides=20'>Roll 3d20</a>"
  client.puts '</pre>'
  rolls.times { client.puts '<p>', rand(sides) + 1, '</p>' }
  client.puts '</body>'
  client.puts '</html>'

  client.close
end
