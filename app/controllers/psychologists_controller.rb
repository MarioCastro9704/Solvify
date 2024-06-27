class PsychologistsController < ApplicationController
  before_action :set_psychologist, only: [:show, :edit, :update, :destroy]

  def index
    @psychologists = Psychologist.all
  end

  def show
    @availabilities = @psychologist.availabilities.where('business_date >= ?', Date.today).order(:business_date, :starting_hour).limit(20)
  end

  def new
    @psychologist = Psychologist.new
  end

  def create
    @psychologist = Psychologist.new(psychologist_params)
    if @psychologist.save
      redirect_to @psychologist, notice: 'Psychologist was successfully created.'
    else
      render :new
    end
  end

  def edit
    @availabilities = @psychologist.availabilities.group_by { |a| a.business_date.wday }
    @time_slots = (7..20).map { |hour| [hour, hour + 1] }  # 7 AM to 8 PM
    @reviews = @psychologist.reviews.includes(:user).order(created_at: :desc)
  end

  def update
    ActiveRecord::Base.transaction do
      @psychologist.update!(psychologist_params)
      update_availabilities
      update_service
    end
    redirect_to @psychologist, notice: 'Psychologist was successfully updated.'
  rescue ActiveRecord::RecordInvalid
    @availabilities = @psychologist.availabilities.group_by { |a| a.business_date.wday }
    @time_slots = (7..20).map { |hour| [hour, hour + 1] }
    @reviews = @psychologist.reviews.includes(:user).order(created_at: :desc)
    render :edit
  end

  def destroy
    @psychologist.destroy
    redirect_to psychologists_url, notice: 'Psychologist was successfully destroyed.'
  end

  private

  def set_psychologist
    @psychologist = Psychologist.find(params[:id])
  end

  def psychologist_params
    params.require(:psychologist).permit(
      :document_of_identity, :approach, :languages, :nationality,
      :price_per_session, :degree, :profile_picture, specialties: [],
      service_attributes: [:id, :visible]
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

  def update_service
    if @psychologist.service && params[:psychologist][:service_attributes]
      @psychologist.service.update!(params[:psychologist][:service_attributes].permit(:visible))
    end
  end
end
