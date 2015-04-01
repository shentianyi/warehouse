position = Position.find_by_detail("00 00 00")
PartPosition.all.each{|pp| pp.destroy if pp.position.nil?}
if position
  Part.all.each{|part|
    puts part.part_positions.where(is_delete:false).count
    if part.part_positions.count == 0
      part.part_positions<<PartPosition.new({position_id:position.id})
      part.save
      puts "#{part.id}:#{position.detail}"
    end
  }
end