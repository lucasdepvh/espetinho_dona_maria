class Customer < ApplicationRecord
  has_many :orders, dependent: :restrict_with_error

  before_validation :normalize_phone

  validates :name, presence: true

  scope :recent, -> { order(updated_at: :desc) }

  def self.find_or_initialize_by_phone(phone)
    normalized = PhoneNormalizer.call(phone)
    return new if normalized.blank?

    find_or_initialize_by(phone: normalized)
  end

  private

  def normalize_phone
    self.phone = PhoneNormalizer.call(phone) if phone.present?
  end
end
