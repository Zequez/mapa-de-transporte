require 'base64'

class MyEncryptor
  def self.encode(data)
    Base64.encode64(data).strip.gsub(/\n|=/, "").reverse
  end

  def self.decode(data)
    Base64.decode64(data.reverse + ("=" * (data.size % 4)))
  end
end