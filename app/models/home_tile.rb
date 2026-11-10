class HomeTile < ApplicationRecord
  COLUMN_SPANS = (1..6).to_a.freeze
  ROW_SPANS = (1..3).to_a.freeze

  belongs_to :photo

  acts_as_list

  validates :photo_id, uniqueness: true
  validates :column_span, inclusion: { in: COLUMN_SPANS }
  validates :row_span, inclusion: { in: ROW_SPANS }

  def image_url
    photo.home_url(column_span)
  end
end
