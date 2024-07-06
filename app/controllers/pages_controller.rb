class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @published_services = Service.published.includes(:psychologist)

    if params[:psychologist_id].present?
      @psychologist = Psychologist.find(params[:psychologist_id])
    end

    start_date = if params[:start_date].present?
                   Date.parse(params[:start_date])
                 else
                   Date.today
                 end

    @dates = calculate_dates(params[:day], start_date)
    @primer_dia = @dates.first

    if @psychologist.present?
      load_availabilities
    end
  end

  def update_dates
    if params[:psychologist_id].present?
      @psychologist = Psychologist.find(params[:psychologist_id])
      @service = Service.find_by(psychologist_id: @psychologist.id)
    end

    start_date = if params[:start_date].present?
                   Date.parse(params[:start_date])
                 else
                   Date.today
                 end

    @dates = calculate_dates(params[:day], start_date)
    @primer_dia = @dates.first

    if @psychologist.present?
      load_availabilities
    end
  end

  private

  def load_availabilities
    @availabilities = @psychologist.availabilities.where('business_date >= ?', @dates.first).where('business_date <= ?', @dates.last).order(:business_date)
  end

  def calculate_dates(day_param, start_date)
    case day_param
    when 'next'
      start_date += 4.days
    when 'prev'
      start_date -= 4.days
    end
    (start_date..start_date + 3.days).to_a
  end
end
