require 'rest-client'
site = RestClient::Resource.new('http://localhost:3000')

res=site['/api/v1/users/login'].post({user:{id:'admin',password:'123456@'}})

puts res.cookies

for i in 1..9
 site['/api/v1/packages'].post({package:{id:"p#{i}",part_id:'311908953',quantity_str:200,check_in_time:'23.08.14'}},{cookies:res.cookies})
end

for i in 1..3
 site['/api/v1/forklifts/check_package'].post({id:"p#{i}",package_id:"p#{i+1}"},{cookies:res.cookies})
end

site['/api/v1/forklifts/check_package'].post({id:'p5',package_id:"p6"},{cookies:res.cookies})

site['/api/v1/forklifts/check_package'].post({id:'p7',package_id:"p8"},{cookies:res.cookies})
site['/api/v1/forklifts/check_package'].post({id:'p7',package_id:"p9"},{cookies:res.cookies})


site['/api/v1/forklifts/check_package'].post({id:'p2',package_id:"p5"},{cookies:res.cookies})
site['/api/v1/forklifts/check_package'].post({id:'p1',package_id:"p7"},{cookies:res.cookies})

res=site['/api/v1/users/login'].post({user:{id:'100001',password:'123456@'}})
site['/api/v1/forklifts/add'].post({id:'p1'},{cookies:res.cookies})


res=site['/api/v1/users/login'].post({user:{id:'111111',password:'123456@'}})
site['/api/v1/forklifts/add'].post({id:'p5'},{cookies:res.cookies})
site['/api/v1/forklifts/add'].post({id:'p7'},{cookies:res.cookies})
site['/api/v1/forklifts/add'].post({id:'p2'},{cookies:res.cookies})
site['/api/v1/forklifts/add'].post({id:'p1'},{cookies:res.cookies})

