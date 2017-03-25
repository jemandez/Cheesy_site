class GroupsController < ApplicationController
  protect_from_forgery prepend: true
  before_action :authenticate_admin!, except: [:index, :show]

  def index
    school_id = params[:school_id]
    generation_id = params[:id]

    @school = School.find(params[:school_id])
    @generation = @school.generations.find(params[:generation_id])
    @groups = @generation.groups


    unless current_admin
      if school_id != session[:school] or generation_id != session[:generation]
        logger.info "Fail evaluation, no allowed resource"
        render :status => 403
      end

      if session[:expires_at] < Time.current
        flash[:notice] = "La sesión ha expirado, ¡vuelve a ingresar!"
        redirect_to access_school_path(school_id)
      end
    end
  end

  def new
    @group = Group.new
    @generation = Generation.find(params[:generation_id])
    @school = School.find(params[:school_id])
  end

  def create
    clean_params =  params[:group].permit(:title, :description)
    @group = Group.new clean_params
    @generation = Generation.find(params[:generation_id])
    @school = School.find(params[:school_id])
    @group.generation = @generation

    if @group.save
      redirect_to school_generation_group_path(@school, @generation, @group)
    else
      render action: 'new'
    end
  end

  def show
    school_id = params[:school_id]
    generation_id = params[:id]


    @group = Group.find params[:id]
    @generation = Generation.find(params[:generation_id])
    @school = School.find(params[:school_id])

    unless current_admin
      if school_id != session[:school] or generation_id != session[:generation]
        logger.info "Fail evaluation, no allowed resource"
        render :status => 403
      end

      if session[:expires_at] < Time.current
        flash[:notice] = "La sesión ha expirado, ¡vuelve a ingresar!"
        redirect_to access_school_path(school_id)
      end
    end
  end

  def edit
    @group = Group.find params[:id]
    @generation = Generation.find(params[:generation_id])
    @school = School.find(params[:school_id])
  end
end
