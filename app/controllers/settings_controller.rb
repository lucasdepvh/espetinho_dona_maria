class SettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!

  def edit
    @setting = Setting.current
  end

  def update
    @setting = Setting.current
    if @setting.update(setting_params)
      redirect_to edit_settings_path, notice: "Configuracoes atualizadas."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def setting_params
    params.require(:setting).permit(:establishment_name, :phone, :kitchen_whatsapp, :address, :default_delivery_fee, :default_final_message)
  end
end
