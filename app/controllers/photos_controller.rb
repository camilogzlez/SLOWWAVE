class PhotosController < ApplicationController
  # skip_before_action :authenticate_user!

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
        params[:categories].shift
        params[:categories].each do |id|
          category = Category.find(id.to_i)
          CategoryPhoto.create(photo: @photo, category: category )
        end
if params[:projects].present?
  params[:projects].shift
  params[:projects].each do |id|
    project = Project.find(id.to_i)
    ProjectPhoto.create(photo: @photo, project: project )
  end
end
      redirect_to photos_path(@photo), notice: "¡Has subido correctamente tu photo!"
    else
      render :new
    end
  end

  def photos_by_category
    @photos = Photo.includes(:categories).where(categories: { name: params[:param] })
  end

  def photos_by_project
    @photos = Photo.includes(:projects).where(projects: { title: params[:param] })
  end

  private

  def photo_params
    params.require(:photo).permit(:title, :description, :date, :location, :photo, project_ids: [])
  end
end
