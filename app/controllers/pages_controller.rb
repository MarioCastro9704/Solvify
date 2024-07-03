class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @published_services = Service.published.includes(:psychologist)
    if params[:psychologist].present?
      @psychologist = Psychologist.find(params[:psychologist_id])
      load_availabilities
    end
  end

  def load_availabilities
    @availabilities = @psychologist.availabilities.where('business_date >= ?', Date.today).order(:business_date).limit(20)
  end
end
