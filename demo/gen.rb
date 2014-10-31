class Gen
  @@container_id=1

  def self.get_container_id
    @@container_id+=1
  end
end