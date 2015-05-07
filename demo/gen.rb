class Gen
  @@container_id=0
  @@container_good_id=0

  def self.get_container_id
    @@container_id+=1
  end

  def self.get_container_good_id
    @@container_good_id+=1
  end
end

