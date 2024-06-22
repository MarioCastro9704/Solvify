class AvailabilitiesController < ApplicationController
  def index
    @availabilities = Availability.all
  end

  def show
    @availability = Availability.find(params[:id])
  end

  def new
    @availability = Availability.new
  end

  def create
    @availability = Availability.new(availability_params)
    if @availability.save
      redirect_to @availability, notice: 'Availability was successfully created.'
    else
      render :new
    end
  end

  def edit
    @availability = Availability.find(params[:id])
  end

  def update
    @availability = Availability.find(params[:id])
    if @availability.update(availability_params)
      redirect_to @availability, notice: 'Availability was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @availability = Availability.find(params[:id])
    @availability.destroy
    redirect_to availabilities_url, notice: 'Availability was successfully destroyed.'
  end

  private

  def availability_params
    params.require(:availability).permit(:psychologist_id, :business_date, :starting_hour, :ending_hour)
  end
end
