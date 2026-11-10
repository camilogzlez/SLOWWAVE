require "test_helper"

class AdminHomeTilesTest < ActionDispatch::IntegrationTest
  PNG = Base64.decode64("iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==")

  setup do
    login_as users(:camilo)
    @photo = photos(:photo1)
    @photo.photo.attach(io: StringIO.new(PNG), filename: "a.png", content_type: "image/png")
    @other = photos(:photo2)
    @other.photo.attach(io: StringIO.new(PNG), filename: "b.png", content_type: "image/png")
  end

  teardown { Warden.test_reset! }

  test "editor lists tiles and only unplaced photos in the pool" do
    tile = HomeTile.create!(photo: @photo)
    get grid_admin_home_tiles_path
    assert_response :success
    assert_select ".hg-tile[data-id='#{tile.id}']"
    assert_select ".hg-pool-item[data-photo-id='#{@photo.id}']", count: 0
    assert_select ".hg-pool-item[data-photo-id='#{@other.id}']"
  end

  test "pool can be filtered by title" do
    get grid_admin_home_tiles_path, params: { q: "faro" }
    assert_select ".hg-pool-item", count: 1
    assert_select ".hg-pool-item[data-photo-id='#{@other.id}']"
  end

  test "create, resize, reorder and remove" do
    post admin_home_tiles_path, params: { photo_id: @photo.id }
    assert_response :success
    assert_select ".hg-tile"
    tile = HomeTile.find_by!(photo: @photo)
    assert_equal [3, 3], [tile.column_span, tile.row_span]

    patch admin_home_tile_path(tile), params: { column_span: 6, row_span: 1 }, as: :json
    assert_response :success
    assert_equal [6, 1], tile.reload.then { |t| [t.column_span, t.row_span] }

    other = HomeTile.create!(photo: @other)
    patch reorder_admin_home_tiles_path, params: { order: [other.id, tile.id] }, as: :json
    assert_response :no_content
    assert_equal [other.id, tile.id], HomeTile.order(:position).pluck(:id)

    delete admin_home_tile_path(tile)
    assert_response :success
    assert_select ".hg-pool-item[data-photo-id='#{@photo.id}']"
    assert Photo.exists?(@photo.id)
    assert_not HomeTile.exists?(tile.id)
  end

  test "rejects invalid spans and duplicate photos" do
    tile = HomeTile.create!(photo: @photo)
    patch admin_home_tile_path(tile), params: { column_span: 9 }, as: :json
    assert_response :unprocessable_entity
    post admin_home_tiles_path, params: { photo_id: @photo.id }
    assert_response :unprocessable_entity
  end

  test "public home renders tiles in order with their spans" do
    HomeTile.create!(photo: @photo, column_span: 6, row_span: 1, position: 2)
    HomeTile.create!(photo: @other, column_span: 2, row_span: 3, position: 1)
    get root_path
    assert_response :success
    assert_select ".gallery-container", count: 2
    assert_select ".gallery-container:nth-child(1).w-2.h-3"
    assert_select ".gallery-container:nth-child(2).w-6.h-1"
  end

  test "home page has no hard-coded cloudinary links" do
    assert_not_includes File.read(Rails.root.join("app/views/photos/index.html.erb")), "res.cloudinary.com"
  end

  test "requires login" do
    Warden.test_reset!
    logout
    get grid_admin_home_tiles_path
    assert_redirected_to new_user_session_path
  end
end
