class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!
  before_action :set_product, only: %i[show edit update destroy]

  def index
    @categories = Category.order(:name)
    @products = Product.includes(:category).order(:name)
    @products = @products.where(category_id: params[:category_id]) if params[:category_id].present?
    @products = @products.where(active: params[:active]) if params[:active].present?
  end

  def show; end

  def new
    @product = Product.new(active: true)
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to @product, notice: "Produto criado."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @product.update(product_params)
      redirect_to @product, notice: "Produto atualizado."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.update!(active: false)
    redirect_to products_path, notice: "Produto desativado."
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:category_id, :name, :description, :price, :active, :featured, :average_preparation_time)
  end
end
