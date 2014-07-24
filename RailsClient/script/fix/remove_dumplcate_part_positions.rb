grouped = PartPosition.all.group_by{|pp|
	[pp.part_id,pp.position_id]
}

grouped.values.each do |duplicates|
	first_one = duplicates.shift
	duplicates.each{|double| double.destroy}
end