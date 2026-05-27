class CustomersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_customer, only: %i[show edit update]

  def index
    @customers = Customer.recent.includes(:orders)
  end

  def show
    @orders = @customer.orders.includes(:order_items).recent
  end

  def edit; end

  def update
    if @customer.update(customer_params)
      redirect_to @customer, notice: "Cliente atualizado."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(:name, :phone, :address)
  end
end
