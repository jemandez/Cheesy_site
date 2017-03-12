class GenerationsController < ApplicationController
  protect_from_forgery prepend: true
  before_action :authenticate_admin!, except: [:index]
  
  def index
    @generations = Generation.all
  end

  def new
    @generation = Generation.new
    @collections = Collection.all
  end

  def create
    new_params = params[:generation].permit(:title, :description, collections: [])

    new_params[:collections] = Collection.find(
      new_params[:collections].delete_if { |x| x.empty? })

    @generation = Generation.new(new_params)


    if @generation.valid?
      @generation.save
      redirect_to events_path
    else
      @collections = Collection.all
      render :new
    end

  end

  def show

  end
end
