class ServicesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_psychologist
  before_action :check_existing_service, only: [:new, :create]

  def new
    @service = current_user.psychologist.build_service
  end

  def create
    @service = current_user.psychologist.build_service(service_params)
    if @service.save
      redirect_to psychologist_path(current_user.psychologist), notice: 'Service was successfully created.'
    else
      render :new
    end
  end

  private

  def ensure_psychologist
    redirect_to root_path, alert: 'Access denied.' unless current_user.psychologist.present?
  end

  def check_existing_service
    if current_user.psychologist.service.present?
      redirect_to edit_service_path(current_user.psychologist.service), alert: 'You already have a service. You can edit it here.'
    end
  end

  def service_params
    params.require(:service).permit(:name, :country, :price_per_session, :specialties)
  end
end
