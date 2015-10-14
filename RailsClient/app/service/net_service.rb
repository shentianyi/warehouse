require 'net/http'

class NetService
  def self.ping
    flag=true
    if $NEED_PING
      begin
        url = URI.parse(Sync::Config.host+'/api/v1/users/ping')
        req = Net::HTTP::Get.new(url.to_s)
        puts url.host
        puts url.port
        http= Net::HTTP.new(url.host, url.port)
        http.open_timeout = 5
        http.read_timeout = 5
        #res = http.start(url.host, url.port) { |http|
        #  puts 'Start Request'
        #  http.request(req)
        #}
        res = http.get(url)
        #puts res.body
        #puts res.code.class
        if res.code.to_i == 200
          flag= true
        else
          flag= false
        end
      rescue
        #puts '-------------'
        flag= false
      end
    end
#puts '-------------'
#puts flag
    return flag
  end
end
