class UsersController < ApplicationController
  before_action :set_dates, only: [:index]

  def index
    @users = User.all
    @bookings = Booking.includes(:psychologist, :user).where(date: @start_date..@end_date)
    @new_booking = Booking.new
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private

  def set_dates
    @start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.today.beginning_of_week
    @end_date = @start_date.end_of_week
  end

  def user_params
    params.require(:user).permit(:name, :last_name, :date_of_birth, :gender, :address, :email, :password, :nationality)
  end
end
