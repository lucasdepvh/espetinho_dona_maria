class DashboardController < ApplicationController
  include ERB::Util

  before_action :set_setting
  before_action :load_cart
  before_action :set_product, only: :add_to_cart

  def index
    @orders_today = logged_in? ? visible_orders.today : Order.none
    @revenue_today = @orders_today.billable.sum(:total)
    @status_counts = logged_in? ? visible_orders.group(:status).count : {}
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

  def add_to_cart
    cart = session_cart
    cart[@product.id.to_s] = cart.fetch(@product.id.to_s, 0) + 1
    session[:dashboard_cart] = cart

    redirect_to dashboard_path(cart: "open"), notice: "#{@product.name} adicionado ao carrinho."
  end

  def update_cart_item
    product = Product.available_for_orders.find(params[:product_id])
    cart = session_cart
    quantity = params[:quantity].to_i

    if quantity.positive?
      cart[product.id.to_s] = quantity
    else
      cart.delete(product.id.to_s)
    end

    session[:dashboard_cart] = cart
    redirect_to dashboard_path(cart: "open"), notice: "Carrinho atualizado."
  end

  def clear_cart
    session[:dashboard_cart] = {}
    redirect_to dashboard_path(cart: "open"), notice: "Carrinho esvaziado."
  end

  def request_cart_whatsapp
    if @cart_items.empty?
      redirect_to dashboard_path(anchor: "cardapio"), alert: "Adicione pelo menos um item ao carrinho."
      return
    end

    redirect_to cart_whatsapp_url, allow_other_host: true
  end

  private

  def set_setting
    @setting = Setting.current
  end

  def load_cart
    @cart_quantities = session_cart
    product_ids = @cart_quantities.keys
    @cart_items = Product.available_for_orders.where(id: product_ids).order(:name).map do |product|
      quantity = @cart_quantities[product.id.to_s].to_i

      next if quantity <= 0

      {
        product: product,
        quantity: quantity,
        total: product.price * quantity
      }
    end.compact

    @cart_total = @cart_items.sum { |item| item[:total] }
    @cart_count = @cart_items.sum { |item| item[:quantity] }
  end

  def set_product
    @product = Product.available_for_orders.find(params[:product_id])
  end

  def session_cart
    session[:dashboard_cart] = session[:dashboard_cart].is_a?(Hash) ? session[:dashboard_cart] : {}
  end

  def cart_whatsapp_url
    "https://wa.me/#{PhoneNormalizer.call(@setting.phone)}?text=#{url_encode(cart_whatsapp_message)}"
  end

  def cart_whatsapp_message
    lines = [
      "🔥 *Solicitação de pedido - #{@setting.establishment_name}*",
      "",
      "*Itens:*"
    ]

    @cart_items.each do |item|
      lines << "#{item[:quantity]}x #{item[:product].name} - #{money(item[:total])}"
    end

    lines.concat([
      "",
      "*Total parcial:* #{money(@cart_total)}",
      "",
      "Quero confirmar esse pedido."
    ])

    lines.join("\n")
  end

  def money(value)
    "R$ #{format('%.2f', value.to_d).tr('.', ',')}"
  end

  def visible_orders
    return Order.none unless logged_in?

    current_user.admin? ? Order.all : current_user.orders
  end
end
