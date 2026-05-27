class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  enum :status, { open: 0, confirmed: 1, preparing: 2, ready: 3, delivered: 4, canceled: 5 }, scopes: false, instance_methods: false
  enum :order_type, { pickup: 0, table: 1, delivery: 2 }, scopes: false, instance_methods: false
  enum :payment_method, { cash: 0, pix: 1, card: 2, credit: 3 }

  accepts_nested_attributes_for :order_items, allow_destroy: true, reject_if: :blank_order_item?

  before_validation :apply_default_delivery_fee
  before_validation :calculate_totals

  validates :status, :order_type, :payment_method, presence: true
  validates :delivery_fee, :subtotal, :total, numericality: { greater_than_or_equal_to: 0 }
  validates :table_number, presence: true, if: :table?
  validates :delivery_address, presence: true, if: :delivery?
  validates :order_items, length: { minimum: 1, message: "adicione pelo menos um item" }

  scope :today, -> { where(created_at: Time.zone.today.all_day) }
  scope :billable, -> { where.not(status: statuses[:canceled]) }
  scope :for_kitchen, -> { where(status: [statuses[:confirmed], statuses[:preparing]]).order(created_at: :asc) }
  scope :recent, -> { order(created_at: :desc) }

  def calculate_totals
    valid_items = order_items.reject(&:marked_for_destruction?)
    valid_items.each(&:calculate_total)
    self.subtotal = valid_items.sum { |item| item.total_price.to_d }
    self.delivery_fee = delivery_fee.to_d
    self.total = subtotal.to_d + delivery_fee.to_d
  end

  def mark_whatsapp_sent!
    update!(whatsapp_sent_at: Time.current)
  end

  def mark_kitchen_whatsapp_sent!
    update!(kitchen_whatsapp_sent_at: Time.current)
  end

  def table?
    order_type == "table"
  end

  def delivery?
    order_type == "delivery"
  end

  def canceled?
    status == "canceled"
  end

  private

  def apply_default_delivery_fee
    self.delivery_fee = Setting.current.default_delivery_fee if delivery? && delivery_fee.blank?
    self.delivery_fee = 0 if delivery_fee.blank?
  end

  def blank_order_item?(attributes)
    attributes["product_id"].blank? && attributes[:product_id].blank?
  end
end
