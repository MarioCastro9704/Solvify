class ReviewsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_psychologist
  before_action :set_review, only: [:show, :edit, :update, :destroy]

  def index
    @reviews = @psychologist.reviews
    @average_rating = @psychologist.average_rating
  end

  def show
    # @review = Review.find(params[:id])
  end

  def new
    @review = Review.new
  end

  def create
    @review = @psychologist.reviews.new(review_params)
    if @review.save
      redirect_to psychologist_reviews_path(@psychologist), notice: 'Review was successfully created.'
    else
      flash[:alert] = "Something went wrong."
      render :new
    end
  end

  def edit
    # @review = Review.find(params[:id])
  end

  def update
    # @review = Review.find(params[:id])
    if @review.update(review_params)
      redirect_to psychologist_reviews_path(@psychologist), notice: 'Review was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    # @review = Review.find(params[:id])
    @review.destroy
    redirect_to psychologist_reviews_path(@psychologist), notice: 'Review was successfully destroyed.'
  end

  private

  def set_psychologist
    @psychologist = Psychologist.find(params[:psychologist_id])
  end

  def set_review
    @review = @psychologist.reviews.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:comments, :ratings).merge(psychologist_id: @psychologist_id)
  end
end
