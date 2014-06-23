require 'net/http'

class NetService
  def self.ping
    if $NEED_PING
      begin
        url = URI.parse($SYNC_HOST+'/api/v1/users/ping')
        req = Net::HTTP::Get.new(url.to_s)
        puts url.host
        puts url.port
        res = Net::HTTP.start(url.host, url.port) { |http|
          http.read_timeout = 15
          puts 'Start Request'
          http.request(req)
        }
        puts res.body
        puts res.code
        if res.code == 200
          return true
        else
          return false
        end
      rescue Net::ReadTimeout
          return false
      end
    end
  end
end