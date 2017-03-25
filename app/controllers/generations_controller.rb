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

  def new
    @generation = Generation.new
    @groups = Group.all
    @school = School.find(params[:school_id])
  end

  def create
    new_params = params[:generation].permit(:title, :description, groups: [])
    @school = School.find(params[:school_id])
    new_params[:groups] = Group.find(
      new_params[:groups].delete_if { |x| x.empty? })

    @generation = Generation.new(new_params)
    @generation.school = @school

    if @generation.valid?
      @generation.save
      redirect_to school_generation_path(@school, @generation)
    else
      flash[:notice] = @generation.errors.messages
      @groups = Group.all
      render :new
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
