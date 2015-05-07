class ContainerGood
  attr_accessor :id, :uuid, :loadable_id, :loadable_type, :loadable, :date, :quantity, :container_id, :container
  # belongs to container
  @@container_goods={}

  def create
    self.id=Gen.get_container_good_id
    @@container_goods[self.id]=self
  end

  def self.find_by_uuid(uuid)
    @@container_goods.values.each do |cd|
      return cd if cd.uuid==uuid
    end
    return nil
  end

  def self.all
    @@container_goods.values
  end
end