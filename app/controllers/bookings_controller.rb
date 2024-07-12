class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_booking, only: %i[show edit update destroy]

  def index
    @bookings = current_user.bookings
  end

  def show
  end

  def new
    @booking = Booking.new
    if params[:psychologist_id].present?
      @psychologist = Psychologist.find(params[:psychologist_id])
      @availabilities = @psychologist.availabilities.where('business_date >= ?', Date.today).order(:business_date)
      @days = @availabilities.map { |a| [I18n.l(a.business_date, format: '%A, %d %B'), a.business_date.to_s] }.uniq
    else
      flash[:alert] = "Por favor, selecciona un psicólogo primero."
      redirect_to psychologists_path
    end
  end

  def create
    @booking = current_user.bookings.new(booking_params)
    @psychologist = Psychologist.find(booking_params[:psychologist_id])

    if @booking.save
      redirect_to booking_summary_path(@booking), notice: 'La reserva se ha creado exitosamente.'
    else
      @availabilities = @psychologist.availabilities.where('business_date >= ?', Date.today).order(:business_date)
      @days = @availabilities.map { |a| [I18n.l(a.business_date, format: '%A, %d %B'), a.business_date.to_s] }.uniq
      render :new
    end
  end

  def summary
    @booking = Booking.find(params[:id])
    @psychologist = @booking.psychologist
  end

  def edit
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def update
    respond_to do |format|
      if @booking.update(booking_params)
        format.html { redirect_to @booking, notice: "La reserva se actualizó correctamente." }
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
      format.html { redirect_to bookings_url, notice: "La reserva se eliminó correctamente." }
      format.json { head :no_content }
      format.js
    end
  end

  private

  def set_booking
    @booking = current_user.bookings.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(:psychologist_id, :date, :time, :end_time, :reason)
  end
end
