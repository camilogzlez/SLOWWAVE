require "application_system_test_case"

class PhotosTest < ApplicationSystemTestCase
  test "visiting the index" do
    visit root_url
    assert_selector "h1", text: "Todas"
    assert_selector ".title", count: Photo.count
  end

  test "a signed in user can create a photo" do
    login_as users(:camilo)

    visit '/photos/new'

    fill_in 'photo_title', with: "Brazil"
    # fill_in 'photo_date', with:
    fill_in 'photo_description', with: "Bahia, brazil"

    click_on "Add Photo"

    assert_equal root_path, page.current_path
    assert_text "Brazil"
  end 
end
