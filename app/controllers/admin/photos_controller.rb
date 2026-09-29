module Admin
  class PhotosController < Admin::ApplicationController
    # Administrate's own #index (search, pagination, ordering) still runs;
    # this only adds the extra data the custom index view's photo cards need.
    before_action :load_card_data, only: [:index]

    def new
      @categories = Category.all
      @subcategories = Subcategory.includes(:category).order(:category_id, :position)
      @projects = Project.all
    end

    def create
      files = Array(params[:files]).reject(&:blank?)
      shared = shared_params

      if files.empty?
        redirect_to new_admin_photo_path, alert: "Please choose at least one file to upload." and return
      end

      created = 0

      ActiveRecord::Base.transaction do
        files.each do |uploaded_file|
          photo = Photo.new(
            title: File.basename(uploaded_file.original_filename, File.extname(uploaded_file.original_filename)),
            date: shared[:date].presence,
            description: shared[:description],
            location: shared[:location],
            user: User.first
          )
          photo.photo.attach(uploaded_file)
          photo.save!

          if shared[:category_id].present?
            CategoryPhoto.create!(
              photo: photo,
              category_id: shared[:category_id],
              subcategory_id: shared[:subcategory_id].presence
            )
          end

          ProjectPhoto.create!(photo: photo, project_id: shared[:project_id]) if shared[:project_id].present?

          created += 1
        end
      end

      redirect_to admin_photos_path, notice: "#{created} photo(s) uploaded."
    rescue => e
      redirect_to new_admin_photo_path, alert: "Upload failed: #{e.message}"
    end

    def quick_update
      photo = Photo.find(params[:id])

      ActiveRecord::Base.transaction do
        photo.update!(quick_update_params)
        sync_categories!(photo, params[:category_ids], params[:subcategory_by_category] || {})
        sync_projects!(photo, params[:project_ids])
      end

      render json: { ok: true }
    rescue => e
      render json: { ok: false, error: e.message }, status: :unprocessable_entity
    end

    private

    def load_card_data
      @all_categories = Category.includes(:subcategories).order(:name)
      @all_projects = Project.order(:title)
    end

    def shared_params
      params.fetch(:shared, {}).permit(:category_id, :subcategory_id, :project_id, :date, :description, :location)
    end

    def quick_update_params
      params.permit(:title, :description, :location)
    end

    def sync_categories!(photo, category_ids, subcategory_by_category)
      category_ids = Array(category_ids).reject(&:blank?).map(&:to_i)
      existing = photo.category_photos.index_by(&:category_id)

      existing.each { |category_id, category_photo| category_photo.destroy! unless category_ids.include?(category_id) }

      category_ids.each do |category_id|
        subcategory_id = subcategory_by_category[category_id.to_s].presence

        if (category_photo = existing[category_id])
          category_photo.update!(subcategory_id: subcategory_id)
        else
          CategoryPhoto.create!(photo:, category_id:, subcategory_id:)
        end
      end
    end

    def sync_projects!(photo, project_ids)
      project_ids = Array(project_ids).reject(&:blank?).map(&:to_i)
      existing_ids = photo.project_photos.pluck(:project_id)

      (existing_ids - project_ids).each { |project_id| photo.project_photos.find_by(project_id:)&.destroy! }
      (project_ids - existing_ids).each { |project_id| ProjectPhoto.create!(photo:, project_id:) }
    end
  end
end
