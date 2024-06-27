class PsychologistsController < ApplicationController
  before_action :set_psychologist, only: [:show, :edit, :update, :destroy]

  def index
    @psychologists = Psychologist.all
  end

  def show
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
    @service = @psychologist.service || @psychologist.build_service
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
    params.require(:psychologist).permit(:specialty, :degree, :document_of_identity, :price_per_hour, specialties: [])
  end
end
