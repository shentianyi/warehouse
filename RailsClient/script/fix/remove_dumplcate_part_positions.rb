grouped = PartPosition.all.group_by{|pp|
	[pp.part_id,pp.position_id]
}

i = 0
grouped.values.each do |duplicates|
	first_one = duplicates.shift
	duplicates.each{|double|
    i = i + 1
    double.destroy
  }
end
puts '删除'+i.to_s+'条冗余数据'