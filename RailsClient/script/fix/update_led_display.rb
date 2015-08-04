Led.all.each do |led|
  if led.led_display.nil?
    led.update({led_display: "0000"})
  end
end

puts "succ."