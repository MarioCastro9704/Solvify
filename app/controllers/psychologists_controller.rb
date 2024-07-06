class PsychologistsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_psychologist, only: [:show, :edit, :update, :destroy, :user_requests]
  before_action :ensure_user_is_not_already_psychologist, only: [:new, :create]

  def index
    @psychologists = Psychologist.all
  end

  def show
    @availabilities = @psychologist.availabilities.where('business_date >= ?', Date.today).order(:business_date, :starting_hour)
  end

  def new
    @psychologist = current_user.build_psychologist
    @psychologist.build_service
  end

  def create
    @psychologist = current_user.build_psychologist(psychologist_params)
    if @psychologist.save
      redirect_to @psychologist, notice: 'El psicólogo fue creado exitosamente.'
    else
      render :new, layout: false
    end
  end

  def edit
    @psychologist.build_service if @psychologist.service.nil?
    load_availability_data
  end

  def update
    if @psychologist.update(psychologist_params)
      handle_profile_picture_upload
      update_availabilities if params[:psychologist][:availabilities].present?
      redirect_to @psychologist, notice: 'El psicólogo fue actualizado exitosamente.'
    else
      load_availability_data
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

  def load_availabilities
    @availabilities = @psychologist.availabilities.where('business_date >= ?', Date.today).order(:business_date)
    render partial: "pages/availabilities", locals: { availabilities: @availabilities }
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
      :full_name, :document_of_identity, :approach, :languages, :nationality,
      :price_per_session, :currency, :degree, :profile_picture, specialties: [],
      service_attributes: [:id, :published, :name, :country, :price_per_session, :specialties]
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

    @psychologist.availabilities.destroy_all

    availabilities_params.each do |day, hours|
      hours.each do |start_hour, value|
        next unless value == "1"

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
