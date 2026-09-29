module Admin
  class CategoriesController < Admin::ApplicationController
    include Admin::Reorderable

    def show
      @category = Category.find(params[:id])
      @subcategories = @category.subcategories
      @category_photos = @category.category_photos
                                  .where(subcategory_id: nil)
                                  .includes(photo: { photo_attachment: :blob })
                                  .order(:position)
      @all_categories = Category.includes(:subcategories).order(:name)
      @all_projects = Project.order(:title)
    end

    def reorder_photos
      category = Category.find(params[:id])
      apply_order!(category.category_photos.where(subcategory_id: nil), Array(params[:order]))
      head :no_content
    rescue ActiveRecord::RecordNotFound
      head :unprocessable_entity
    end

    def reorder_subcategories
      category = Category.find(params[:id])
      apply_order!(category.subcategories, Array(params[:order]))
      head :no_content
    rescue ActiveRecord::RecordNotFound
      head :unprocessable_entity
    end
  end
end
