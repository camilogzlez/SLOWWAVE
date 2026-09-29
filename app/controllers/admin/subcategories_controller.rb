module Admin
  class SubcategoriesController < Admin::ApplicationController
    include Admin::Reorderable

    def show
      @subcategory = Subcategory.find(params[:id])
      @category_photos = @subcategory.category_photos
                                     .includes(photo: { photo_attachment: :blob })
                                     .order(:position)
      @all_categories = Category.includes(:subcategories).order(:name)
      @all_projects = Project.order(:title)
    end

    def reorder_photos
      subcategory = Subcategory.find(params[:id])
      apply_order!(subcategory.category_photos, Array(params[:order]))
      head :no_content
    rescue ActiveRecord::RecordNotFound
      head :unprocessable_entity
    end

    def quick_update
      subcategory = Subcategory.find(params[:id])
      subcategory.update!(name: params[:name])
      render json: { ok: true }
    rescue StandardError => e
      render json: { ok: false, error: e.message }, status: :unprocessable_entity
    end
  end
end
