require 'mercadopago'

class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_booking, only: %i[show edit update destroy summary success failure pending payment]

  def index
    @bookings = current_user.bookings
  end

  def show
    @message = Message.new
  end

  def new
    @booking = Booking.new
    if params[:psychologist_id].present?
      @psychologist = Psychologist.find(params[:psychologist_id])
      @availabilities = @psychologist.availabilities.where('business_date >= ? AND reserved = ?', Date.today, false).order(:business_date)
      @days = @availabilities.map { |a| [I18n.l(a.business_date, format: '%A, %d %B'), a.business_date.to_s] }.uniq
    else
      flash[:alert] = "Por favor, selecciona un psicólogo primero."
      redirect_to psychologists_path
    end
  end

  def create
    @booking = current_user.bookings.new(booking_params)
    @psychologist = Psychologist.find(booking_params[:psychologist_id])
    availability = Availability.find_by(psychologist: @psychologist, business_date: booking_params[:date], starting_hour: booking_params[:time])

    if availability && !availability.reserved && @booking.save
      current_user.update(user_params)
      availability.update(reserved: true)
      redirect_to booking_summary_path(@booking), notice: 'La reserva se ha creado exitosamente.'
    else
      @availabilities = @psychologist.availabilities.where('business_date >= ? AND reserved = ?', Date.today, false).order(:business_date)
      @days = @availabilities.map { |a| [I18n.l(a.business_date, format: '%A, %d %B'), a.business_date.to_s] }.uniq
      flash[:alert] = "No se pudo crear la reserva. Intente de nuevo."
      render :new
    end
  end

  def summary
    @psychologist = @booking.psychologist
    @preference_id = create_preference(@booking)
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

  def success
    @booking.update(payment_status: 'paid')
    redirect_to user_bookings_path(current_user), notice: 'El pago fue exitoso. Ahora puedes acceder a la videollamada.'
  end

  def failure
    flash[:alert] = 'El pago falló. Por favor, inténtalo de nuevo.'
    render :payment_failure
  end

  def pending
    flash[:notice] = 'El pago está pendiente. Te notificaremos cuando se complete.'
    render :payment_pending
  end

  def payment
    @preference_id = create_preference(@booking)

    if @preference_id.present?
      redirect_to "https://www.mercadopago.cl/checkout/v1/redirect?pref_id=#{@preference_id}", allow_other_host: true
    else
      flash[:alert] = 'Hubo un problema al procesar el pago. Por favor, inténtalo de nuevo.'
      redirect_to booking_summary_path(@booking)
    end
  end


  private

  def create_preference(booking)
    sdk = Mercadopago::SDK.new(ENV['MERCADOPAGO_ACCESS_TOKEN'])

    preference_data = {
      items: [
        {
          title: "Sesión con #{booking.psychologist.user.name}",
          unit_price: booking.psychologist.price_per_session.to_i,
          quantity: 1,
          currency_id: 'CLP'
        }
      ],
      payer: {
        name: current_user.name,
        surname: current_user.last_name,
        email: current_user.email
      },
      back_urls: {
        success: success_booking_url(booking),
        failure: failure_booking_url(booking),
        pending: pending_booking_url(booking)
      },
      auto_return: 'approved'
    }

    begin
      preference_response = sdk.preference.create(preference_data)
      preference = preference_response[:response]

      if preference && preference['id']
        preference['id']
      else
        Rails.logger.error("Error creating MercadoPago preference: #{preference_response.inspect}")
        nil
      end
    rescue StandardError => e
      Rails.logger.error("Exception creating MercadoPago preference: #{e.message}")
      nil
    end
  end

  def set_booking
    @booking = if current_user.psychologist.present?
                 Booking.find(params[:id])
               else
                 current_user.bookings.find(params[:id])
               end

    unless @booking
      flash[:alert] = "No se encontró la reserva."
      redirect_to bookings_path
    end
  end

  def booking_params
    params.require(:booking).permit(:psychologist_id, :date, :time, :reason, user_attributes: [:document_of_identity, :name, :last_name, :gender, :phone, :email])
  end

  def user_params
    params.require(:booking).require(:user).permit(:document_of_identity, :name, :last_name, :gender, :phone, :email)
  end
end
