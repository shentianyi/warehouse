nrs=Position.all.pluck(:nr).uniq
nrs.each do |nr|
  ps=Position.where(nr: nr)
  i=0
  ps.each do |pi|
    i+=1
    if i==1
      next
    else
      puts '------'
      pi.destroy
    end
  end
end
  
