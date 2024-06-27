class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @published_services = Service.published.includes(:psychologist)
  end
end
