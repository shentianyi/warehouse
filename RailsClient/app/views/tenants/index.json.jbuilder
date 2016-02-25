json.array!(@tenants) do |tenant|
  json.extract! tenant, :id, :name, :code, :address, :email, :tel, :website, :type
  json.url tenant_url(tenant, format: :json)
end
