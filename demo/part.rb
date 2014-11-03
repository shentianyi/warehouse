require_relative 'container_good'
class Loadable
  def can_load?(uuid)
    ContainerGood.find_by_uuid(uuid).nil?
  end

  def load(args={})
    if self.can_load?(args[:uuid])
      cd=ContainerGood.new
      cd.container=args[:container]
      cd.container_id =cd.container.id
      cd.loadable=self
      cd.loadable_id=self.id
      cd.loadable_type =self.class.name
      cd.uuid =args[:uuid]
      cd.quantity = args[:quantity]
      cd.date=args[:date]
      cd.create
    else
      puts 'can not load..'+self.id.to_s+':' +args[:uuid]
    end
  end
end

class Part<Loadable
  attr_accessor :id, :name
  #has many container_goods
end