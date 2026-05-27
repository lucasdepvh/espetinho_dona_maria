class Setting < ApplicationRecord
  before_validation :normalize_phones

  validates :establishment_name, presence: true
  validates :default_delivery_fee, numericality: { greater_than_or_equal_to: 0 }
  validate :single_record, on: :create

  DEFAULT_FINAL_MESSAGE = "Obrigado pela preferencia! Seu pedido foi registrado e em breve daremos andamento.".freeze

  def self.current
    first_or_create!(
      establishment_name: "Espetinho Dona Maria",
      phone: "5569999999999",
      kitchen_whatsapp: "5569999999999",
      address: "Endereco da espetaria",
      default_delivery_fee: 0,
      default_final_message: DEFAULT_FINAL_MESSAGE
    )
  end

  private

  def normalize_phones
    self.phone = PhoneNormalizer.call(phone) if phone.present?
    self.kitchen_whatsapp = PhoneNormalizer.call(kitchen_whatsapp) if kitchen_whatsapp.present?
  end

  def single_record
    errors.add(:base, "ja existe uma configuracao principal") if Setting.exists?
  end
end
