class PhotosController < ApplicationController
  skip_before_action :authenticate_user!
  
 def index
    @photos = Photo.all
  end
  
  def new
    @photo = Photo.new
  end

  def create
    @photo = Photo.new(photo_params)
    @photo.user = current_user
    if @photo.save
      redirect_to photos_path(@photo)
    else
      raise
      render :new
    end
  end
  

  private

  def photo_params
    params.require(:photo).permit(:title, :description, :date, :location, :photo)
  end
end
