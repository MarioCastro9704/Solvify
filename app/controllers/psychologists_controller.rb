class PsychologistsController < ApplicationController
  def index
    @psychologists = Psychologist.all
  end

  def show
    @psychologist = Psychologist.find(params[:id])
  end

  def new
    @psychologist = Psychologist.new
  end

  def create
    @psychologist = Psychologist.new(psychologist_params)
    if @psychologist.save
      redirect_to @psychologist, notice: 'Psychologist was successfully created.'
    else
      render :new
    end
  end

  def edit
    @psychologist = Psychologist.find(params[:id])
  end

  def update
    @psychologist = Psychologist.find(params[:id])
    if @psychologist.update(psychologist_params)
      redirect_to @psychologist, notice: 'Psychologist was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @psychologist = Psychologist.find(params[:id])
    @psychologist.destroy
    redirect_to psychologists_url, notice: 'Psychologist was successfully destroyed.'
  end

  private

  def psychologist_params
    params.require(:psychologist).permit(:user_id, :specialty, :degree, :document_of_identity, :availability, :years_of_experience, :description, :average_rating, :price_per_hour)
  end
end
