class GenerationsController < ApplicationController
  protect_from_forgery prepend: true
  before_action :authenticate_admin!, except: [:index]
  
  def index
    @generations = Generation.all
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
    @school = School.find(params[:school_id])
    @generation = Generation.find(params[:id])
  end
end
