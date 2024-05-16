require "administrate/base_dashboard"

class PhotoDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    categories: Field::HasMany,
    category_photos: Field::HasMany,
    date: Field::DateTime,
    description: Field::Text,
    location: Field::String,
    photo: CloudinaryAttachmentField,
    project_photos: Field::HasMany,
    projects: Field::HasMany,
    title: Field::String,
    user: Field::BelongsTo, # Add this line to define the user attribute
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  COLLECTION_ATTRIBUTES = %i[
    id
    categories
    category_photos
    date
    photo
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    categories
    date
    description
    location
    photo
    projects
    title
    user
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  FORM_ATTRIBUTES = %i[
    categories
    date
    description
    location
    photo
    projects
    title
    user
  ].freeze

  # COLLECTION_FILTERS
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how photos are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(photo)
  #   "Photo ##{photo.id}"
  # end
end
