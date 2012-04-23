def recursive_symbolize_keys!(hash)
  hash = hash.symbolize_keys!
  hash.each_pair do |key, value|
    hash[key] = recursive_symbolize_keys!(value) if value.is_a? Hash
  end
end

CONFIG = recursive_symbolize_keys!(YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env])