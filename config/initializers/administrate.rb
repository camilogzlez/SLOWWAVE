# Load our custom admin styles (photo/subcategory cards, drag handles, nav)
# on every admin page, not just the ones that opt in via content_for(:stylesheet).
Administrate::Engine.add_stylesheet("admin_sortable_grid")
