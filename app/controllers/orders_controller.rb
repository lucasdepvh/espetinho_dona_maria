class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: %i[show edit update destroy update_status cancel whatsapp kitchen_whatsapp]
  before_action :load_form_data, only: %i[new edit create update]

  def index
    @orders = Order.includes(:customer, :user).recent
    @orders = @orders.where(status: params[:status]) if params[:status].present?
  end

  def show; end

  def new
    @order = current_user.orders.new(delivery_fee: Setting.current.default_delivery_fee)
    5.times { @order.order_items.build }
  end

  def create
    @order = current_user.orders.new(order_params)
    @order.customer = resolve_customer

    if @order.save
      redirect_to @order, notice: "Pedido criado."
    else
      @order.order_items.build if @order.order_items.empty?
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    (5 - @order.order_items.size).times { @order.order_items.build }
  end

  def update
    @order.assign_attributes(order_params)
    @order.customer = resolve_customer if customer_submitted?

    if @order.save
      redirect_to @order, notice: "Pedido atualizado."
    else
      @order.order_items.build if @order.order_items.empty?
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @order.update!(status: :canceled)
    redirect_to orders_path, notice: "Pedido cancelado."
  end

  def update_status
    if @order.update(status: params[:status])
      redirect_back fallback_location: @order, notice: "Status atualizado."
    else
      redirect_back fallback_location: @order, alert: "Nao foi possivel atualizar o status."
    end
  end

  def cancel
    @order.update!(status: :canceled)
    redirect_back fallback_location: orders_path, notice: "Pedido cancelado."
  end

  def whatsapp
    @order.mark_whatsapp_sent!
    redirect_to WhatsappMessageBuilder.new(@order).customer_url, allow_other_host: true
  end

  def kitchen_whatsapp
    @order.mark_kitchen_whatsapp_sent!
    redirect_to WhatsappMessageBuilder.new(@order).kitchen_url, allow_other_host: true
  end

  private

  def set_order
    @order = Order.includes(order_items: :product).find(params[:id])
  end

  def load_form_data
    @customers = Customer.order(:name)
    @products = Product.available_for_orders.includes(:category).order("categories.name", :name)
  end

  def resolve_customer
    return Customer.find(params.dig(:order, :customer_id)) if params.dig(:order, :customer_id).present?

    customer = Customer.find_or_initialize_by_phone(params[:customer_phone])
    customer.name = params[:customer_name].presence || customer.name
    customer.address = params[:customer_address].presence || customer.address
    customer.save!
    customer
  end

  def customer_submitted?
    params.dig(:order, :customer_id).present? || params[:customer_name].present? || params[:customer_phone].present?
  end

  def order_params
    params.require(:order).permit(
      :status, :order_type, :table_number, :delivery_address, :payment_method,
      :change_for, :delivery_fee, :notes,
      order_items_attributes: %i[id product_id quantity notes _destroy]
    )
  end
end
