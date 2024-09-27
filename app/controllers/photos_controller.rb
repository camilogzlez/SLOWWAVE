class PhotosController < ApplicationController
  before_action :authenticate_user!, only: [:new]

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
      if params[:categories].present? && params[:categories].any?
        params[:categories].shift # Remove the first element, which is an empty string
        params[:categories].each do |id|
          category = Category.find(id.to_i)
          CategoryPhoto.create(photo: @photo, category: category)
        end
      end

      if params[:projects].present? && params[:projects].any?
        params[:projects].shift # Remove the first element, which is an empty string
        params[:projects].each do |id|
          project = Project.find(id.to_i)
          ProjectPhoto.create(photo: @photo, project: project)
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
    @photos = Photo.includes(:projects)
                 .where(projects: { title: params[:param] })
                 .order('project_photos.position ASC')
  end

  private

  def photo_params
    params.require(:photo).permit(:title, :description, :date, :location, :photo, project_ids: [])
  end
end
