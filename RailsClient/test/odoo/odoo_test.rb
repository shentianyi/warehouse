#encoding: utf-8
require "xmlrpc/client"
# info = XMLRPC::Client.new2('https://demo.odoo.com/start').call('start')
# url, db, username, password = info['host'], info['database'], info['user'], info['password']
# p info

db='junnuo'
username='admin'
password='123456@'

url ='http://42.121.111.38:8000'
common = XMLRPC::Client.new2("#{url}/xmlrpc/2/common")
p common.call('version')

uid = common.call('authenticate', db, username, password, {})
puts uid

models = XMLRPC::Client.new2("#{url}/xmlrpc/2/object").proxy

partners=models.execute_kw(db, uid, password,
                  'res.partner', 'search',
                  [[['is_company', '=', true], ['customer', '=', true]]])
p partners