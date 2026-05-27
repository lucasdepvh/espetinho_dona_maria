class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!
  before_action :set_user, only: %i[show edit update destroy]

  def index
    @users = User.order(:name)
  end

  def show; end

  def new
    @user = User.new(active: true, role: :attendant)
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user, notice: "Usuario criado."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    permitted = user_params
    permitted = permitted.except(:password, :password_confirmation) if permitted[:password].blank?

    if @user.update(permitted)
      redirect_to @user, notice: "Usuario atualizado."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.update!(active: false)
    redirect_to users_path, notice: "Usuario desativado."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role, :active)
  end
end
