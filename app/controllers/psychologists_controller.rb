class PsychologistsController < ApplicationController
  before_action :set_psychologist, only: [:show, :edit, :update, :destroy, :load_availabilities]

  def index
    @psychologists = Psychologist.all
  end

  def show
    @availabilities = @psychologist.availabilities.where('business_date >= ?', Date.today).order(:business_date, :starting_hour).limit(20)
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
    @availabilities = @psychologist.availabilities.group_by { |a| a.business_date.wday }
    @time_slots = (7..20).map { |hour| [hour, hour + 1] }
  end

  def update
    assign_service_attributes
    if @psychologist.update(psychologist_params)
      update_availabilities if params[:psychologist][:availabilities].present?
      redirect_to @psychologist, notice: 'Psychologist was successfully updated.'
    else
      @availabilities = @psychologist.availabilities.group_by { |a| a.business_date.wday }
      @time_slots = (7..20).map { |hour| [hour, hour + 1] }
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @psychologist.destroy
    redirect_to psychologists_url, notice: 'Psychologist was successfully destroyed.'
  end

  # def load_availabilities
  #   @availabilities = @psychologist.availabilities.where('business_date >= ?', Date.today).order(:business_date).limit(20)
  #   render partial: "pages/availabilities", locals: { availabilities: @availabilities }
  # end

  private

  def set_psychologist
    @psychologist = Psychologist.find(params[:id])
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
      specialties: @psychologist.specialties.join(', '),  # Converting array to string
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
