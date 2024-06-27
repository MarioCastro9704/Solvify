class PsychologistsController < ApplicationController
  before_action :set_psychologist, only: [:show, :edit, :update, :destroy]

  def index
    @psychologists = Psychologist.all
  end

  def show
    @availabilities = @psychologist.availabilities.where('start_time > ?', Time.now).order(:start_time).limit(20)
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
  end

  def update
    if @psychologist.update(psychologist_params)
      redirect_to @psychologist, notice: 'Psychologist was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @psychologist.destroy
    redirect_to psychologists_url, notice: 'Psychologist was successfully destroyed.'
  end

  private

  def set_psychologist
    @psychologist = Psychologist.find(params[:id])
  end

  def psychologist_params
    params.require(:psychologist).permit(:document_of_identity, :approach, :languages, :nationality, :price_per_session, :degree, specialties: [])
  end
end
