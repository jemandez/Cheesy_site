class GenerationsController < ApplicationController
  protect_from_forgery prepend: true
  before_action :authenticate_admin!, except: [:index, :show]
  before_action :validate_session, only: [:index]

  def index
    @generations = []

    if current_admin
      @school = School.find(params[:school_id])
      @generations = @school.generations
    end
  end

  def edit
    @generation = Generation.find(params[:id])
    @groups = Group.all
    @school = School.find(params[:school_id])
  end

  def update
    new_params = params[:generation].permit(:password, :description)
    @school = School.find(params[:school_id])

    @generation = Generation.find(params[:id])

    if @generation.update_attributes(new_params)
      redirect_to school_generation_path(@school, @generation)
    else
      flash[:notice] = @generation.errors.messages
      @groups = Group.all
      render :edit
    end

  end

  def show
    school_id = params[:school_id]
    generation_id = params[:id]

    if current_admin
      @school = School.find(school_id)
      @generation = Generation.find(generation_id)
    elsif school_id == session[:school] and generation_id == session[:generation]
      logger.info "Session school: #{session[:school] == school_id}"
      logger.info "Session generation: #{session[:generation]}:#{generation_id}"
      logger.info "Session expires at: #{session[:expires_at] > Time.current}"

      if session[:expires_at] < Time.current
        flash[:notice] = "La sesión ha expirado, ¡vuelve a ingresar!"
        redirect_to access_school_path(school_id)
      end

      @school = School.find(school_id)
      @generation = Generation.find(generation_id)

      logger.info "Evaluate session: ok"
    else
      logger.info "Fail evaluation, no allowed resource"
      render :status => 403
    end
  end
end
