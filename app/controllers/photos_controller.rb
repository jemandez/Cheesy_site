class PhotosController < ApplicationController
  protect_from_forgery prepend: true
  before_action :authenticate_admin!
  before_action :fill_attr, only: [:new, :create]


  #def index
  #  @photos = Photo.all
  #end

  def new
  end

  def create

    if @photo.valid?
      @photo.save
      redirect_to collections_path(@group)
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

    @photo.collection = @group = Group.find(Integer(params[:collection_id]))
  end

end
