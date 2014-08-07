json.array!(@sys_configs) do |sys_config|
  json.extract! sys_config, :id, :key, :value, :name
  json.url sys_config_url(sys_config, format: :json)
end
