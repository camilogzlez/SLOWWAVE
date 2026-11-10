require "test_helper"

class AdminAccessTest < ActionDispatch::IntegrationTest
  setup do
    @stranger = User.create!(email: "stranger@example.com", password: "password123")
  end

  teardown do
    Warden.test_reset!
    ENV["ADMIN_EMAIL"] = "camilogzlez@gmail.com"
  end

  ADMIN_PATHS = %w[/admin /admin/photos /admin/users /admin/home_tiles/grid].freeze

  test "public sign-up is gone" do
    assert_not_includes User.devise_modules, :registerable
    assert_raises(ActionController::RoutingError) { get "/users/sign_up" }
  end

  test "the login page still works" do
    get new_user_session_path
    assert_response :success
    assert_select "a[href*='sign_up']", count: 0
  end

  test "visitors are sent to login" do
    ADMIN_PATHS.each do |path|
      get path
      assert_redirected_to new_user_session_path, path
    end
  end

  test "another logged-in user is turned away from every admin page" do
    login_as @stranger
    ADMIN_PATHS.each do |path|
      get path
      assert_redirected_to root_path, path
    end
  end

  test "another logged-in user cannot delete photos or tiles" do
    login_as @stranger
    photo = photos(:photo1)
    delete admin_photo_path(photo)
    delete bulk_destroy_admin_photos_path, params: { photo_ids: [photo.id] }, as: :json
    post admin_home_tiles_path, params: { photo_id: photo.id }
    assert Photo.exists?(photo.id)
    assert_equal 0, HomeTile.count
  end

  test "another logged-in user cannot use the public upload page" do
    login_as @stranger
    get new_photo_path
    assert_redirected_to root_path
    assert_no_difference "Photo.count" do
      post photos_path, params: { photo: { title: "x" } }
    end
    assert_redirected_to root_path
  end

  test "the admin account gets in, whatever the email's case" do
    ENV["ADMIN_EMAIL"] = " CamiloGzlez@gmail.com "
    login_as users(:camilo)
    ADMIN_PATHS.each do |path|
      get path
      assert_response :success, path
    end
  end

  test "nobody gets in when ADMIN_EMAIL is unset" do
    ENV.delete("ADMIN_EMAIL")
    login_as users(:camilo)
    get admin_photos_path
    assert_redirected_to root_path
  end

  test "home page marks its grid so rows stay even, galleries do not" do
    get root_path
    assert_select ".containersup.home-grid"
    get photos_by_category_path(param: "nope")
    assert_response :redirect
    assert_not_includes File.read(Rails.root.join("app/views/photos/photos_by_category.html.erb")), "home-grid"
  end
end
