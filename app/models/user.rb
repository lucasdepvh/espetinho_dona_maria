class User < ApplicationRecord
  has_secure_password

  enum :role, { attendant: 0, admin: 1 }

  has_many :orders, dependent: :restrict_with_error

  before_validation :normalize_email

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :role, presence: true

  scope :active, -> { where(active: true) }

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end
end
