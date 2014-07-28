items=[]
3.times do
  %w(418000319 414264960 414370340).each do |part|
    items<<{department: '3MB', part_id: part, quantity: 1000, is_emergency: false}
  end
end
params={order: {}, order_items: items}
u=User.find_by_id('admin')
o=OrderService.create_with_items(params, u)
o.source_id='l002'
o.save