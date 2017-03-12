class GroupsController < ApplicationController
  protect_from_forgery prepend: true
  before_action :authenticate_admin!, except: [:index, :show]

  def index
    @groups = Group.all
    @generation = Generation.find(params[:generation_id])
    @school = School.find(params[:school_id])
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
    @group = Group.find params[:id]
    @generation = Generation.find(params[:generation_id])
    @school = School.find(params[:school_id])
  end

  def edit
    @group = Group.find params[:id]
    @generation = Generation.find(params[:generation_id])
    @school = School.find(params[:school_id])
  end
end
