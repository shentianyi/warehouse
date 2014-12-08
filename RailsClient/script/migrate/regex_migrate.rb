RegexType.types.each do |type|
  if RegexCategory.where(name: RegexType.display(type), type:type).count == 0
    rc=RegexCategory.new(name: RegexType.display(type), type: type)
    Regex.where(type: type).each do |r|
      rc.regexes<<r
    end
    rc.save
  end
end