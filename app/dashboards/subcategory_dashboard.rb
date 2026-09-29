require "administrate/base_dashboard"

class SubcategoryDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    name: Field::String,
    category: Field::BelongsTo,
    cover_photo: Field::BelongsTo.with_options(class_name: "Photo"),
    position: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    id
    name
    category
    cover_photo
    position
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id
    name
    category
    cover_photo
    position
    created_at
    updated_at
  ].freeze

  FORM_ATTRIBUTES = %i[
    name
    category
    cover_photo
  ].freeze

  COLLECTION_FILTERS = {}.freeze

  def display_resource(subcategory)
    "#{subcategory.category.name} / #{subcategory.name}"
  end
end
