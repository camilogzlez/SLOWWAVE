class Photo < ApplicationRecord
  # Each distinct set of options is a separate Cloudinary transformation, so every
  # page shares these two sizes.
  THUMBNAIL_OPTIONS = { width: 600, height: 600, crop: :fill, quality: :auto, fetch_format: :auto, secure: true }.freeze
  FULL_OPTIONS = { width: 1200, crop: :limit, quality: :auto, fetch_format: :auto, secure: true }.freeze
  HOME_OPTIONS = { width: 1000, crop: :limit, quality: :auto, fetch_format: :auto, secure: true }.freeze
  HOME_LARGE_OPTIONS = HOME_OPTIONS.merge(width: 1400).freeze
  HOME_LARGE_MIN_COLUMNS = 4

  # Exports at 2400px / quality 85 are about 0.6 MB; anything far bigger is
  # almost certainly a full-resolution original uploaded by mistake.
  MAX_UPLOAD_SIZE = 3.megabytes

  belongs_to :user
  has_one_attached :photo
  has_many :category_photos, dependent: :destroy
  has_many :categories, through: :category_photos
  has_many :project_photos, dependent: :destroy
  has_many :projects, through: :project_photos
  has_one :home_tile, dependent: :destroy
  has_many :covered_subcategories, class_name: "Subcategory", foreign_key: :cover_photo_id, dependent: :nullify
  # acts_as_list

  validate :photo_within_upload_size

  def thumbnail_url
    image_url(THUMBNAIL_OPTIONS)
  end

  def full_url
    image_url(FULL_OPTIONS)
  end

  def home_url(column_span)
    image_url(column_span >= HOME_LARGE_MIN_COLUMNS ? HOME_LARGE_OPTIONS : HOME_OPTIONS)
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

  def self.upload_size_label
    "#{MAX_UPLOAD_SIZE / 1.megabyte} MB"
  end

  private

  def photo_within_upload_size
    return unless photo.attached? && attachment_changes["photo"]
    return if photo.blob.byte_size <= MAX_UPLOAD_SIZE

    errors.add(:photo, "must be #{self.class.upload_size_label} or smaller")
  end

  def image_url(options)
    return unless photo.attached?
    return Rails.application.routes.url_helpers.rails_blob_path(photo, only_path: true) if photo.blob.service_name.in?(%w[local test])

    Cloudinary::Utils.cloudinary_url(photo.key, options.dup)
  end
end
