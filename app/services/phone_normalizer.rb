class PhoneNormalizer
  def self.call(phone)
    new(phone).call
  end

  def initialize(phone)
    @phone = phone.to_s
  end

  def call
    digits = @phone.gsub(/\D/, "")
    return "" if digits.blank?

    digits.start_with?("55") ? digits : "55#{digits}"
  end
end
