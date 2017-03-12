class GenerationsController < ApplicationController
  protect_from_forgery prepend: true
  before_action :authenticate_admin!, except: [:index]
  
  def index
    @generations = Generation.all
  end

  def new
    @generation = Generation.new
    @groups = Group.all
  end

  def create
    new_params = params[:generation].permit(:title, :description, groups: [])

    new_params[:groups] = Group.find(
      new_params[:groups].delete_if { |x| x.empty? })

    @generation = Generation.new(new_params)


    if @generation.valid?
      @generation.save
      redirect_to events_path
    else
      @groups = Group.all
      render :new
    end

  end

  def show

  end
end
