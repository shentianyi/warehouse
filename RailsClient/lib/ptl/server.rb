require 'socket'
module Ptl
  class Server

    attr_accessor :server, :clients

    def self.run
      job_t=Thread.new { execute_job }
      server_info=SysConfig.led_server.split(':')
      server_info=['192.168.1.101',8899]
      $led_socket =TCPServer.open(server_info[0], server_info[1].to_i)

      puts "[#{Time.now}]---start tcpsever: #{server_info}---"
      server_t=Thread.new { run_server }
      puts "[#{Time.now}]----- tcp server started----"
      job_t.join
      server_t.join
    end

    def self.run_server
      loop {
        # for each user connected and accepted by server, it will create a new thread object
        # and which pass the connected client as an instance to the block
        Thread.new($led_socket.accept) do |client|
          puts "[#{Time.now}]new client--- #{client_info(client)}"
          $led_socket_clients[client_info(client)]=client
          self.receive_message(client)
        end
      }
    end

    def self.receive_message(client)
      puts "[#{Time.now}]-----start linsten to #{client_info(client)}"
      loop {
        Thread.new do
          message = client.gets
          puts "[#{Time.now}]new client message--- #{client_info(client)}:#{message}"
          Ptl::Message::Parser.dispatch(message)
        end
      }
    end

    def self.execute_job
      puts "[#{Time.now}]-- start execute mysql job"
      loop {
        # Thread.start do
        sleep(3)
        puts "[#{Time.now}]-- executing mysql job"
        Ptl::Job.out_queue
        # end
      }
    end

    def self.send_message(message)
      $led_socket_clients.each do |k, c|
        begin
          unless c.closed?
            c.puts message
          end
        rescue => e
          puts e
          begin
            $led_socket_clients.delete(k)
          rescue => ee
            puts ee.message
          end
        end
      end
    end

    #
    def self.client_info(client)
      "#{client.remote_address.ip_address}:#{client.remote_address.ip_port}"
    end
  end
end