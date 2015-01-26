Regex.all.each{|reg|
  reg.update({id:reg.code})
}

RegexType.types.each do |type|
  if RegexCategory.where(id:type,name: RegexType.display(type), type:type).count == 0
    rc=RegexCategory.new(id:type,name: RegexType.display(type), type: type)
    Regex.where(type: type).each do |r|
      rc.regexes<<r
    end
    rc.save
  end
end