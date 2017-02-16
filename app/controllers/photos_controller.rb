class PhotosController < ApplicationController
  before_action :fill_attr, only: [:new, :create]

  #def index
  #  @photos = Photo.all
  #end

  def new
  end

  def create

    if @photo.valid?
      @photo.save
      redirect_to collections_path(@collection)
    else
      render action: 'new'
    end
  end

  private

  def fill_attr
    if params.key?(:photo)
      @photo = Photo.new(params[:photo].permit(:title, :description, :url))
    else
      @photo = Photo.new
    end

    @photo.collection = @collection = Collection.find(Integer(params[:collection_id]))
  end

end
