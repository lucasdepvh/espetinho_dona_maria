class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!
  before_action :set_category, only: %i[show edit update destroy]

  def index
    @categories = Category.order(:name)
  end

  def show; end

  def new
    @category = Category.new(active: true)
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to @category, notice: "Categoria criada."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @category.update(category_params)
      redirect_to @category, notice: "Categoria atualizada."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.update!(active: false)
    redirect_to categories_path, notice: "Categoria desativada."
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :description, :active)
  end
end
