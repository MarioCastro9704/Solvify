class PsychologistsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_psychologist, only: [:show, :edit, :update, :destroy, :user_requests]
  before_action :ensure_user_is_not_already_psychologist, only: [:new, :create]

  def index
    @psychologists = Psychologist.all
  end

  def show
    @availabilities = @psychologist.availabilities.where('business_date >= ?', Date.today).order(:business_date, :starting_hour).limit(20)
  end

  def new
    @psychologist = current_user.build_psychologist
    @psychologist.build_service
  end

  def create
    @psychologist = current_user.build_psychologist(psychologist_params)
    assign_service_attributes
    if @psychologist.save
      redirect_to @psychologist, notice: 'El psicólogo fue creado exitosamente.'
    else
      # Renderizar sin el sidebar y topbar en caso de error
      render :new, layout: false
    end
  end

  def edit
    @psychologist.build_service if @psychologist.service.nil?
    @availabilities = @psychologist.availabilities.group_by { |a| a.business_date.wday }
    @time_slots = (7..20).map { |hour| [hour, hour + 1] }
  end

  def update
    assign_service_attributes
    if @psychologist.update(psychologist_params)
      update_availabilities if params[:psychologist][:availabilities].present?
      redirect_to @psychologist, notice: 'El psicólogo fue actualizado exitosamente.'
    else
      @availabilities = @psychologist.availabilities.group_by { |a| a.business_date.wday }
      @time_slots = (7..20).map { |hour| [hour, hour + 1] }
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @psychologist.destroy
    redirect_to psychologists_url, notice: 'El psicólogo fue eliminado exitosamente.'
  end

  def user_requests
    @requests = @psychologist.bookings.includes(:user)
  end

  private

  def set_psychologist
    @psychologist = Psychologist.find(params[:id])
  end

  def ensure_user_is_not_already_psychologist
    if current_user.psychologist.present?
      redirect_to root_path, alert: 'Ya eres un psicólogo registrado.'
    end
  end

  def psychologist_params
    params.require(:psychologist).permit(
      :document_of_identity, :approach, :languages, :nationality,
      :price_per_session, :currency, :degree, :profile_picture, specialties: [],
      service_attributes: [:id, :published]
    )
  end

  def assign_service_attributes
    @psychologist.build_service if @psychologist.service.nil?
    @psychologist.service.assign_attributes(
      name: @psychologist.full_name,
      country: @psychologist.nationality,
      price_per_session: @psychologist.price_per_session,
      specialties: @psychologist.specialties.join(', '),
      published: @psychologist.service.published
    )
  end

  def update_availabilities
    availabilities_params = params[:psychologist][:availabilities]
    return unless availabilities_params

    @psychologist.availabilities.destroy_all

    availabilities_params.each do |day, hours|
      hours.each do |start_hour, value|
        next unless value == "1"

        date = Date.today.beginning_of_week + day.to_i.days
        @psychologist.availabilities.create!(
          business_date: date,
          starting_hour: Time.zone.parse("#{start_hour}:00"),
          ending_hour: Time.zone.parse("#{(start_hour.to_i + 1)}:00")
        )
      end
    end
  end
end
