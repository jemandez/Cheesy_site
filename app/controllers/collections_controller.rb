class CollectionsController < ApplicationController
  protect_from_forgery prepend: true
  before_action :authenticate_admin!, except: [:index, :show]

  def index
    @collections = Collection.all
  end

  def new
    @collection = Collection.new
  end

  def create
    clean_params =  params[:collection].permit(:title, :description)
    @collection = Collection.new clean_params

    if @collection.save
      redirect_to collections_path
    else
      render action: 'new'
    end
  end

  def show
    @collection = Collection.find params[:id]
  end

  def edit
    @collection = Collection.find params[:id]
  end
end
