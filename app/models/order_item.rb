class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  before_validation :copy_current_product_price, on: :create
  before_validation :calculate_total

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :unit_price, :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def calculate_total
    copy_current_product_price
    self.quantity = quantity.to_i
    self.unit_price = unit_price.to_d
    self.total_price = quantity * unit_price
  end

  private

  def copy_current_product_price
    self.unit_price = product.price if product.present? && unit_price.blank?
  end
end
