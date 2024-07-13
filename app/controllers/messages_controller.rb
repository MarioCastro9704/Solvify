class MessagesController < ApplicationController
  def create
    @booking = Booking.find(params[:booking_id])
    @message = Message.new(message_params)
    @message.booking = @booking
    @message.user = current_user
    if @message.save
      Turbo::StreamsChannel.broadcast_append_to @booking, target: "messages", partial: "bookings/message", locals: { message: @message, current_user: current_user}
      # redirect_to booking_path(@booking)
    else
      render "bookings/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :user_id, :booking_id)
  end
end
