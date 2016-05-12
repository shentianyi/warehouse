#encoding: utf-8
#  p source.class
#  p source
# p source= source.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')


require "xmlrpc/client"
# info = XMLRPC::Client.new2('https://demo.odoo.com/start').call('start')
# url, db, username, password = info['host'], info['database'], info['user'], info['password']
# p info

db='Junnuo'
username='admin'
password='123456@'

#init common
url ='http://42.121.111.38:8000'
common = XMLRPC::Client.new2("#{url}/xmlrpc/2/common")
p common.call('version')

# get login
uid = common.call('authenticate', db, username, password, {})
puts uid


models = XMLRPC::Client.new2("#{url}/xmlrpc/2/object").proxy

#search
partners=models.execute_kw(db, uid, password,
                  'res.partner', 'search',
                  [[['is_company', '=', true], ['customer', '=', true]]])
p partners

#search count
scount=models.execute_kw(db, uid, password,
                  'res.partner', 'search_count',
                  [[['is_company', '=', true], ['customer', '=', true]]])
p scount

#read
records = models.execute_kw(db, uid, password,
                           'res.partner', 'read', [partners])
records.each do |r|
  p r
end

# list record fields
fields=models.execute_kw(
    db, uid, password, 'res.partner', 'fields_get',
    [], {attributes: %w(string help type)})

p fields

# search and read
sr=models.execute_kw(db, uid, password,
                  'res.partner', 'search_read',
                  [[['is_company', '=', true], ['customer', '=', true]]],
                  {fields: %w(name country_id comment), limit: 5})

sr.each{|s| p s}

# create
id = models.execute_kw(db, uid, password, 'res.partner', 'create', [{
                                                                        name: "New Partner",
                                                                        is_company: 'true'
                                                                    }])
p id