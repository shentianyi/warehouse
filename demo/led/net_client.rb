require 'net/tcp_client'

Net::TCPClient.connect(
  server:                 '192.168.0.101:8000',
  connect_retry_interval: 0.1,
  connect_retry_count:    5
) do |client|

	puts client.methods.sort
  # If the connection is lost, create a new one and retry the send
  client.retry_on_connection_failure do
    client.write('Update the database')
  end
  response = client.read(20)
  puts "Received: #{response}"
end
