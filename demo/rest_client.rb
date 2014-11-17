require 'rest-client'
require 'json'
site = RestClient::Resource.new('http://localhost:3000')

res=site['/api/v1/users/login'].post({user:{id:'admin',password:'123456@'}})

cookies= res.cookies

package_count=20
for i in 1..package_count
 site['/api/v1/packages'].post({package:{id:"p#{i}",part_id:'311908953',quantity_str:200,check_in_time:'23.08.14'}},{cookies:cookies})
end

per=4
forklift_count=package_count/per
fs=[]
forklift_count.times do
  res=site['/api/v1/forklifts'].post({forklift:{whouse_id:'3CP'}},{cookies:cookies})
  fs<<JSON.parse(res.body)['content']['id']
end

puts fs

fs.each_with_index do |f,i|
  for j in 1..per
    res=site['/api/v1/forklifts/check_package'].post({forklift_id:f,package_id:"p#{j+i*per}"}, {cookies:cookies})
#  puts JSON.parse(res.body)
  end
end




# for i in 1..3
#  site['/api/v1/forklifts/add'].post({id:"p#{i}",pid:"p#{i+1}"},{cookies:res.cookies})
# end
#
# site['/api/v1/forklifts/add'].post({id:'p5',pid:"p6"},{cookies:res.cookies})
#
# site['/api/v1/forklifts/add'].post({id:'p7',pid:"p8"},{cookies:res.cookies})
# site['/api/v1/forklifts/add'].post({id:'p7',pid:"p9"},{cookies:res.cookies})
#
#
# site['/api/v1/forklifts/add'].post({id:'p2',pid:"p5"},{cookies:res.cookies})
# site['/api/v1/forklifts/add'].post({id:'p1',pid:"p7"},{cookies:res.cookies})

# res=site['/api/v1/users/login'].post({user:{id:'100001',password:'123456@'}})
# site['/api/v1/forklifts/add'].post({id:'p1'},{cookies:res.cookies})
#
#
# res=site['/api/v1/users/login'].post({user:{id:'111111',password:'123456@'}})
# site['/api/v1/forklifts/add'].post({id:'p5'},{cookies:res.cookies})
# site['/api/v1/forklifts/add'].post({id:'p7'},{cookies:res.cookies})
# site['/api/v1/forklifts/add'].post({id:'p2'},{cookies:res.cookies})
# site['/api/v1/forklifts/add'].post({id:'p1'},{cookies:res.cookies})

