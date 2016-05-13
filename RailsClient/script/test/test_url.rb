# require 'net/http/persistent'
#
# # uri = URI 'https://us.sso.covisint.com/sso?cmd=LOGIN'
# uri = URI 'localhost:3000'
#
# http = Net::HTTP::Persistent.new 'my_app_name'
#
# # perform a GET
# response = http.request uri
#
# # create a POST
# # post_uri = uri
# # post = Net::HTTP::Post.new post_uri.path
# # post.set_form_data 'some' => 'cool data'
# #
# # # perform the POST, the URI is always required
# # response = http.request post_uri, post
# #
# # # if you are done making http requests, or won't make requests for several
# # # minutes
# # http.shutdown

require 'net/http'
require "open-uri"

params={
    auth_mode: 'basic',
    langSelect: 16,
    submitTime:(Time.now.to_f*1000).to_i,
    user: 'MRJX',
    password: '19841018',
    rememberUsername: true
}
uri = URI.parse("https://us.sso.covisint.com/sso?cmd=LOGIN")
res = Net::HTTP.post_form(uri, params)
#返回的cookie
puts co=res.header['set-cookie']
#返回的html body
puts res.body
#
#

# uri = URI.parse("https://portal.covisint.com/web/portal/home")
# http = Net::HTTP.new(uri.host, uri.port)
# request = Net::HTTP::Get.new(uri.request_uri)
# response = http.request(request)
# p response

http = Net::HTTP.new("portal.covisint.com")
request = Net::HTTP::Get.new("/web/messaging/jiaxuan-supplyonline")
response = http.request(request)
p response

request = Net::HTTP::Get.new("/so-supplychain-portlet/fordScheduleExcelFile.ajax?headerId=9059&userSsoId=&siteLanguage=en")
response = http.request(request)
p response

p response

