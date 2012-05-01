require 'base64'

class MyEncryptor
  def self.encode(data)
    Base64.encode64(data).strip.gsub(/\n|=/, "").reverse
  end

  def self.decode(data)
    Base64.decode64(data.reverse + ("=" * (data.size % 4)))
  end

  def self.domain_validator(domain)
    sum = 0
    domain.each_codepoint {|l|sum += l*l}
    sum.to_s
  end
end