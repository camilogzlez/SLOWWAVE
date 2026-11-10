module Admin
  class HomeTilesController < Admin::ApplicationController
    include Admin::Reorderable

    POOL_PHOTOS_PER_PAGE = 30

    def grid
      @home_tiles = HomeTile.includes(photo: { photo_attachment: :blob }).order(:position)
      @categories = Category.order(:name)
      @pool_photos = pool_photos
    end

    def create
      tile = HomeTile.create!(photo: Photo.find(params[:photo_id]))
      render partial: "admin/home_tiles/tile", locals: { tile: tile }
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound => e
      render plain: e.message, status: :unprocessable_entity
    end

    def update
      tile = HomeTile.find(params[:id])
      tile.update!(params.permit(:column_span, :row_span))
      render json: { ok: true, image_url: tile.image_url }
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound => e
      render json: { ok: false, error: e.message }, status: :unprocessable_entity
    end

    def destroy
      tile = HomeTile.find(params[:id])
      tile.destroy!
      render partial: "admin/home_tiles/pool_item", locals: { photo: tile.photo }
    end

    def reorder
      apply_order!(HomeTile.all, Array(params[:order]))
      head :no_content
    rescue ActiveRecord::RecordNotFound
      head :unprocessable_entity
    end

    private

    def pool_photos
      photos = Photo.with_attached_photo.where.not(id: HomeTile.select(:photo_id)).order(created_at: :desc)
      photos = photos.where("photos.title ILIKE ?", "%#{Photo.sanitize_sql_like(params[:q])}%") if params[:q].present?
      photos = photos.where(id: CategoryPhoto.where(category_id: params[:category_id]).select(:photo_id)) if params[:category_id].present?
      photos.page(params[:page]).per(POOL_PHOTOS_PER_PAGE)
    end
  end
end
