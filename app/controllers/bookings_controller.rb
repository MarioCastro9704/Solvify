class BookingsController < ApplicationController
  before_action :set_booking, only: %i[show edit update destroy]

  def index
    @bookings = Booking.all
  end

  def show
  end

  def new
    @booking = Booking.new
    if params[:psychologist_id].present?
      @psychologist = Psychologist.find(params[:psychologist_id])
      @availabilities = @psychologist.availabilities.where('business_date >= ?', Date.today).order(:business_date)

      # Generar un array de los próximos 7 días
      @days = (Date.today..Date.today + 6.days).map do |date|
        [I18n.l(date, format: '%A, %d %B'), date.to_s]
      end
    else
      flash[:alert] = "Please select a psychologist first."
      redirect_to psychologists_path
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def create
    @booking = Booking.new(booking_params)
    @psychologist = Psychologist.find(booking_params[:psychologist_id])

    if @booking.save
      redirect_to @booking, notice: 'Booking was successfully created.'
    else
      @availabilities = @psychologist.availabilities.where('business_date >= ?', Date.today).order(:business_date)
      @days_of_week = @availabilities.map { |a| [a.business_date.strftime("%A"), a.business_date] }.uniq
      render :new
    end
  end

  def update
    respond_to do |format|
      if @booking.update(booking_params)
        format.html { redirect_to @booking, notice: "Booking was successfully updated." }
        format.json { render :show, status: :ok, location: @booking }
      else
        format.html { render :edit }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @booking.destroy
    respond_to do |format|
      format.html { redirect_to bookings_url, notice: "Booking was successfully destroyed." }
      format.json { head :no_content }
      format.js   # Añadir esto para responder a AJAX
    end
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(:day_of_week, :time, :psychologist_id)
  end
end
