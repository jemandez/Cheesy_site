class PhotosController < ApplicationController
  def index
    @photos = Photo.all
  end

  def new
    @photo = Photo.new
  end

  def create
    @photo = Photo.new(params[:photo].permit(:title, :description))

    if @photo.valid?
      redirect_to photos_path
    else
      render action: 'new'
    end
  end
end
