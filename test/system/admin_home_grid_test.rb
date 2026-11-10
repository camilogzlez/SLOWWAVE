require "application_system_test_case"

class AdminHomeGridTest < ApplicationSystemTestCase
  PNG = Base64.decode64("iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==")

  setup do
    login_as users(:camilo)
    @a = photos(:photo1)
    @b = photos(:photo2)
    [@a, @b].each { |p| p.photo.attach(io: StringIO.new(PNG), filename: "a.png", content_type: "image/png") }
  end

  teardown { Warden.test_reset! }

  test "drag a photo in, resize it, reorder, and remove it" do
    visit grid_admin_home_tiles_path

    find(".hg-pool-item[data-photo-id='#{@a.id}']").drag_to(find("#home-grid"), html5: true)
    assert_selector "#home-grid .hg-tile[data-id]", count: 1
    assert_no_selector ".hg-pool-item[data-photo-id='#{@a.id}']"
    assert_no_selector ".hg-tile--placeholder"
    tile_a = HomeTile.find_by!(photo: @a)

    find(".hg-pool-item[data-photo-id='#{@b.id}'] .hg-add").click
    assert_selector "#home-grid .hg-tile[data-id]", count: 2
    tile_b = HomeTile.find_by!(photo: @b)
    wait_for { HomeTile.order(:position).pluck(:id) == [tile_a.id, tile_b.id] }

    within(".hg-tile[data-id='#{tile_a.id}']") do
      find(".hg-column-span").select("6")
      find(".hg-row-span").select("1")
    end
    wait_for { tile_a.reload.column_span == 6 && tile_a.row_span == 1 }
    assert_includes find(".hg-tile[data-id='#{tile_a.id}']")[:style], "span 6"

    find(".hg-tile[data-id='#{tile_b.id}']").drag_to(find(".hg-tile[data-id='#{tile_a.id}']"), html5: true)
    wait_for { HomeTile.order(:position).pluck(:id) == [tile_b.id, tile_a.id] }

    find(".hg-tile[data-id='#{tile_b.id}'] .hg-remove").click
    assert_selector ".hg-pool-item[data-photo-id='#{@b.id}']"
    assert_no_selector ".hg-tile[data-id='#{tile_b.id}']"
    assert_not HomeTile.exists?(tile_b.id)
  end

  test "select photos and bulk add them to a project, then delete" do
    Project.create!(title: "Tango")
    visit admin_photos_path
    assert_no_selector ".bulk-toolbar"

    find(".photo-card[data-photo-id='#{@a.id}'] .pc-select-checkbox").check
    assert_selector ".bulk-toolbar .bulk-count", text: "1"
    find(".bulk-select-all").click
    assert_selector ".bulk-toolbar .bulk-count", text: Photo.count.to_s

    find(".bulk-project").select("Tango")
    find(".bulk-add-project").click
    wait_for { ProjectPhoto.count == Photo.count }
    assert_selector_after_reload ".flash-notice, .flash", text: "photo(s) updated"

    find(".photo-card[data-photo-id='#{@a.id}'] .pc-select-checkbox").check
    accept_confirm { find(".bulk-delete").click }
    wait_for { !Photo.exists?(@a.id) }
    assert_selector_after_reload ".flash-notice, .flash", text: "1 photo(s) deleted"
  end

  test "upload form warns about oversized files before sending" do
    big = Rails.root.join("tmp", "big_upload_test.jpg")
    File.binwrite(big, "x" * (Photo::MAX_UPLOAD_SIZE + 1))
    visit new_admin_photo_path
    attach_file "upload-files", big
    assert_text "big_upload_test.jpg"
    assert find("#upload-submit").disabled?
  ensure
    File.delete(big) if big && File.exist?(big)
  end

  private

  # The page reloads itself after a bulk action; the driver can lose its node mid-reload.
  def assert_selector_after_reload(selector, **options)
    assert_selector(selector, **options)
  rescue Selenium::WebDriver::Error::UnknownError, Selenium::WebDriver::Error::StaleElementReferenceError
    sleep 0.3
    assert_selector(selector, **options)
  end

  def wait_for(timeout: 5)
    deadline = Time.current + timeout
    until yield
      flunk "condition not met in time" if Time.current > deadline
      sleep 0.1
    end
  end
end
