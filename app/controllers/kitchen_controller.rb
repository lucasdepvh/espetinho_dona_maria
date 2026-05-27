class KitchenController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = Order.for_kitchen.includes(:customer, order_items: :product)
  end
end
