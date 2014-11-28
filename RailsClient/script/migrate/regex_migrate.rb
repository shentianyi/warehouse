RegexType.types.each do |type|
  rc=RegexCategory.new(name: RegexType.display(type), type: type)
  Regex.where(type: type).each do |r|
    rc.regexes<<r
  end
  rc.save
end