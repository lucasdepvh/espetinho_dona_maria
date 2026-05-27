class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @setting = Setting.current
    @orders_today = Order.today
    @revenue_today = @orders_today.billable.sum(:total)
    @status_counts = Order.group(:status).count
    @latest_orders = visible_orders.includes(:customer).recent.limit(4)
    @categories = Category.active.includes(:products).order(:name)
    @featured_products = Product.available_for_orders.includes(:category).featured.order(:name).limit(2)
    @popular_products = Product.available_for_orders.includes(:category).order(featured: :desc, name: :asc).limit(6)
    @active_orders_count = visible_orders.where(status: %i[open confirmed preparing ready]).count
    @featured_products = @popular_products.first(2) if @featured_products.empty?
  end

  def show
    index
    render :index
  end

  private

  def visible_orders
    current_user.admin? ? Order.all : current_user.orders
  end
end
