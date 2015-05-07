json.array!(@leds) do |led|
  json.extract! led, :id, :id, :signal_id, :name, :modem_id, :position_id
  json.url led_url(led, format: :json)
end
