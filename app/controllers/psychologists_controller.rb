class PsychologistsController < ApplicationController
  before_action :set_psychologist, only: [:show, :edit, :update, :destroy, :load_availabilities, :user_requests]

  def index
    @psychologists = Psychologist.all
  end

  def show
    @availabilities = @psychologist.availabilities.where('business_date >= ?', Date.today).order(:business_date, :starting_hour)
  end

  def new
    @psychologist = Psychologist.new
    @psychologist.build_service
  end

  def create
    @psychologist = Psychologist.new(psychologist_params)
    assign_service_attributes
    if @psychologist.save
      redirect_to @psychologist, notice: 'Psychologist was successfully created.'
    else
      render :new
    end
  end

  def edit
    @psychologist.build_service if @psychologist.service.nil?
    load_availability_data
  end

  def update
    assign_service_attributes
    if @psychologist.update(psychologist_params)
      handle_profile_picture_upload
      update_availabilities if params[:psychologist][:availabilities].present?
      redirect_to @psychologist, notice: 'Psychologist was successfully updated.'
    else
      load_availability_data
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @psychologist.destroy
    redirect_to psychologists_url, notice: 'Psychologist was successfully destroyed.'
  end

  def user_requests
    @requests = @psychologist.bookings.includes(:user)
  end

  def load_availabilities
    @availabilities = @psychologist.availabilities.where('business_date >= ?', Date.today).order(:business_date)
    render partial: "pages/availabilities", locals: { availabilities: @availabilities }
  end

  private

  def set_psychologist
    @psychologist = Psychologist.find(params[:id])
  end

  def psychologist_params
    params.require(:psychologist).permit(
      :full_name, :document_of_identity, :approach, :languages, :nationality,
      :price_per_session, :currency, :degree, :profile_picture, specialties: []
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

  def handle_profile_picture_upload
    if params[:psychologist][:profile_picture].present?
      @psychologist.profile_picture.attach(params[:psychologist][:profile_picture])
    end
  end

  def update_availabilities
    availabilities_params = params[:psychologist][:availabilities]
    return unless availabilities_params

    # Eliminar todas las disponibilidades existentes para este psicólogo
    @psychologist.availabilities.destroy_all

    # Crear nuevas disponibilidades basadas en los parámetros enviados
    availabilities_params.each do |day, hours|
      hours.each do |start_hour, value|
        next unless value == "1"

        # Crear una nueva disponibilidad para cada semana a partir de la fecha actual
        4.times do |week_offset|
          date = Date.today.beginning_of_week + day.to_i.days + (week_offset * 7).days
          @psychologist.availabilities.create!(
            business_date: date,
            starting_hour: Time.zone.parse("#{start_hour}:00"),
            ending_hour: Time.zone.parse("#{(start_hour.to_i + 1)}:00")
          )
        end
      end
    end
  end

  def load_availability_data
    @availabilities = @psychologist.availabilities.group_by { |a| a.business_date.wday }
    @time_slots = (7..20).map { |hour| [hour, hour + 1] }
  end
end
