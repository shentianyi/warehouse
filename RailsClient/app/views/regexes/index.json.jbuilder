json.array!(@regexes) do |regex|
  json.extract! regex, :id, :name, :code, :prefix_length, :prefix_string, :type, :suffix_length, :suffix_string, :regex_string, :localtion_id
  json.url regex_url(regex, format: :json)
end
