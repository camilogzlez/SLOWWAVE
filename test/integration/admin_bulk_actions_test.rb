require "test_helper"

class AdminBulkActionsTest < ActionDispatch::IntegrationTest
  PNG = Base64.decode64("iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==")

  setup do
    login_as users(:camilo)
    @a = photos(:photo1)
    @b = photos(:photo2)
    [@a, @b].each { |p| p.photo.attach(io: StringIO.new(PNG), filename: "a.png", content_type: "image/png") }
    @category = Category.create!(name: "Street")
    @subcategory = Subcategory.create!(name: "Night", category: @category)
    @project = Project.create!(title: "Tango")
  end

  teardown { Warden.test_reset! }

  test "adds photos to a category without duplicating" do
    CategoryPhoto.create!(photo: @a, category: @category)
    post bulk_assign_admin_photos_path, params: { photo_ids: [@a.id, @b.id], category_id: @category.id }, as: :json
    assert_response :success
    assert_equal [@a.id, @b.id].sort, CategoryPhoto.where(category: @category).pluck(:photo_id).sort
  end

  test "adds photos to a subcategory" do
    post bulk_assign_admin_photos_path, params: { photo_ids: [@a.id], category_id: @category.id, subcategory_id: @subcategory.id }, as: :json
    assert_response :success
    assert_equal @subcategory.id, CategoryPhoto.find_by(photo: @a, category: @category).subcategory_id
  end

  test "keeps the existing subcategory when none is chosen" do
    CategoryPhoto.create!(photo: @a, category: @category, subcategory: @subcategory)
    post bulk_assign_admin_photos_path, params: { photo_ids: [@a.id], category_id: @category.id, subcategory_id: "" }, as: :json
    assert_response :success
    assert_equal @subcategory.id, CategoryPhoto.find_by(photo: @a, category: @category).subcategory_id
  end

  test "rejects a subcategory from another category and changes nothing" do
    other = Category.create!(name: "Other")
    post bulk_assign_admin_photos_path, params: { photo_ids: [@a.id, @b.id], category_id: other.id, subcategory_id: @subcategory.id }, as: :json
    assert_response :unprocessable_entity
    assert_equal 0, CategoryPhoto.where(category: other).count
  end

  test "adds photos to a project without duplicating" do
    ProjectPhoto.create!(photo: @a, project: @project)
    post bulk_assign_admin_photos_path, params: { photo_ids: [@a.id, @b.id], project_id: @project.id }, as: :json
    assert_response :success
    assert_equal 2, ProjectPhoto.where(project: @project).count
  end

  test "deletes photos even when used elsewhere" do
    CategoryPhoto.create!(photo: @a, category: @category)
    ProjectPhoto.create!(photo: @a, project: @project)
    HomeTile.create!(photo: @a)
    @subcategory.update!(cover_photo: @a)

    delete bulk_destroy_admin_photos_path, params: { photo_ids: [@a.id, @b.id] }, as: :json

    assert_response :success
    assert_not Photo.exists?(@a.id)
    assert_not Photo.exists?(@b.id)
    assert_equal 0, HomeTile.count
    assert_nil @subcategory.reload.cover_photo_id
  end

  test "requires a selection and a target" do
    delete bulk_destroy_admin_photos_path, params: { photo_ids: [] }, as: :json
    assert_response :unprocessable_entity
    post bulk_assign_admin_photos_path, params: { photo_ids: [@a.id] }, as: :json
    assert_response :unprocessable_entity
    assert Photo.exists?(@a.id)
  end

  test "toolbar is on every admin view with photo cards" do
    CategoryPhoto.create!(photo: @a, category: @category)
    CategoryPhoto.create!(photo: @b, category: @category, subcategory: @subcategory)
    ProjectPhoto.create!(photo: @a, project: @project)

    [admin_photos_path, admin_category_path(@category), admin_subcategory_path(@subcategory), admin_project_path(@project)].each do |path|
      get path
      assert_response :success, path
      assert_select ".bulk-toolbar", { count: 1 }, path
      assert_select ".pc-select-checkbox", { minimum: 1 }, path
    end
  end
end
