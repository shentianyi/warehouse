require 'rest-client'
#message='<00000216                                    R00000001C00038>'
url='http://192.168.0.101:9001/led/message/send/%3C00000256%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20R00000001C00044%3E'
c= RestClient::Resource.new(url,
						                                   timeout: nil,
														                                    open_time_out: nil,
																							                                 content_type: 'application/json'
         )

c.post(nil)

