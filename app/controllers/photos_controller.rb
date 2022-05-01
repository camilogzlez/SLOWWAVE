class PhotosController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @photos = Photo.all
  end

  def show
    @photo = Photo.find(params[:id])
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
      render :new
    end
  end

  def photos_by_category
    @photos = Photo.includes(:categories).where(categories: { name: params[:param] })
  end

  private

  def photo_params
    params.require(:photo).permit(:title, :description, :date, :location, :photo)
  end
end
