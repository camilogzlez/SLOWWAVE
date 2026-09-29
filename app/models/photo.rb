class Photo < ApplicationRecord
  belongs_to :user
  has_one_attached :photo
  has_many :category_photos, dependent: :destroy
  has_many :categories, through: :category_photos
  has_many :project_photos, dependent: :destroy
  has_many :projects, through: :project_photos
  # acts_as_list

  def thumbnail_url(width: 50, height: 50)
    # Generate the Cloudinary URL for the attached photo
    if photo.attached?
      Cloudinary::Utils.cloudinary_url(photo.key, width:, height:, crop: :fill)
    end
  end

  def category_names
    categories.map(&:name).join(', ')
  end

  def project_titles
    projects.map(&:title).join(', ')
  end

  def subcategory_names
    category_photos.includes(:subcategory).filter_map { |cp| cp.subcategory&.name }.join(', ')
  end
end
