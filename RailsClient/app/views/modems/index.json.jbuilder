json.array!(@modems) do |modem|
  json.extract! modem, :id, :id, :name, :ip
  json.url modem_url(modem, format: :json)
end
