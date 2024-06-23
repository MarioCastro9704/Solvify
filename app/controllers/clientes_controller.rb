class ClientesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_psychologist

  def index
    @clientes = current_user.psychologist.clientes
  end

  private

  def require_psychologist
    redirect_to root_path unless current_user.psychologist.present?
  end
end
