module Admin
  module Reorderable
    extend ActiveSupport::Concern

    private

    # Persists a full ordering in one shot: `scoped_relation` must already be
    # narrowed to the parent (project/category/subcategory) so a submitted id
    # that doesn't belong to it raises RecordNotFound instead of silently
    # reordering someone else's rows.
    def apply_order!(scoped_relation, ids)
      ActiveRecord::Base.transaction do
        ids.each_with_index do |id, index|
          scoped_relation.find(id).update_column(:position, index + 1)
        end
      end
    end
  end
end
