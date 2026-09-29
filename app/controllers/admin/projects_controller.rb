module Admin
  class ProjectsController < Admin::ApplicationController
    include Admin::Reorderable

    def show
      @project = Project.find(params[:id])
      @project_photos = @project.project_photos.includes(photo: { photo_attachment: :blob }).order(:position)
      @all_categories = Category.includes(:subcategories).order(:name)
      @all_projects = Project.order(:title)
    end

    def reorder_photos
      project = Project.find(params[:id])
      apply_order!(project.project_photos, Array(params[:order]))
      head :no_content
    rescue ActiveRecord::RecordNotFound
      head :unprocessable_entity
    end
  end
end
