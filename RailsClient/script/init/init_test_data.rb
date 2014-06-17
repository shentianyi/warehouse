L1 = Location.create(id:'l001',name:'Outter Warehouse',address:'Shanghai',tel:'2913123')
L2 = Location.create(id:'l002',name:'Factory',address:'Suzhou',tel:'2123913123')

Whouse.create(id:'wh001',name:'3MB',location_id:'L002')
Whouse.create(id:'wh002',name:'3GM',location_id:'L002')
p1 = Position.create(id:'ps001',whouse_id:'wh001',detail:'02 01 04')
p2 = Position.create(id:'ps002',whouse_id:'wh001',detail:'02 01 04')
p3 = Position.create(id:'ps003',whouse_id:'wh002',detail:'03 01 04')
p4 = Position.create(id:'ps004',whouse_id:'wh002',detail:'03 02 04')

u1 = User.create(id:'user001',password:'1111',password_confirmation:'1111')
u1.location = L1
u1.role_id = 300
u1.save

u2 = User.create(id:'user002',password:'1111',password_confirmation:'1111')
u2.location = L1
u2.role_id = 400
u2.save

u3 = User.create(id:'user003',password:'1111',password_confirmation:'1111')
u3.location = L1
u3.role_id = 100
u3.save

Part.create(id:'PT001',user_id:'user001')
Part.create(id:'PT002',user_id:'user001')

PartPosition.create(part_id:'PT001',position_id:p1.id,whouse_id:'wh001')
PartPosition.create(part_id:'PT002',position_id:p2.id,whouse_id:'wh001')
PartPosition.create(part_id:'PT001',position_id:p3.id,whouse_id:'wh002')
PartPosition.create(part_id:'PT002',position_id:p4.id,whouse_id:'wh002')
