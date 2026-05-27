class Product < ApplicationRecord
  belongs_to :category

  has_many :order_items, dependent: :restrict_with_error

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :category, presence: true

  scope :active, -> { where(active: true) }
  scope :available_for_orders, -> { active.joins(:category).merge(Category.active) }
  scope :featured, -> { where(featured: true) }
end
