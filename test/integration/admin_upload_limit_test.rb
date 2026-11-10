require "test_helper"

class AdminUploadLimitTest < ActionDispatch::IntegrationTest
  setup { login_as users(:camilo) }
  teardown { Warden.test_reset! }

  def upload(name, bytes)
    file = Tempfile.new([name, ".jpg"])
    file.binmode
    file.write("\xFF\xD8\xFF".b + ("\x00".b * (bytes - 3)))
    file.rewind
    assert_equal bytes, file.size
    Rack::Test::UploadedFile.new(file.path, "image/jpeg", true, original_filename: "#{name}.jpg")
  end

  test "small files are uploaded" do
    assert_difference "Photo.count", 2 do
      post admin_photos_path, params: { files: [upload("small1", 600_000), upload("small2", 900_000)] }
    end
    assert_redirected_to admin_photos_path
  end

  test "one big file rejects the whole batch and names it" do
    assert_no_difference ["Photo.count", "ActiveStorage::Blob.count"] do
      post admin_photos_path, params: { files: [upload("small", 600_000), upload("DSCF5470", 4.megabytes)] }
    end
    assert_redirected_to new_admin_photo_path
    follow_redirect!
    assert_match "DSCF5470.jpg", response.body
    assert_no_match "small.jpg", flash[:alert].to_s
  end

  test "a file exactly at the limit is accepted" do
    assert_difference "Photo.count", 1 do
      post admin_photos_path, params: { files: [upload("edge", Photo::MAX_UPLOAD_SIZE)] }
    end
  end

  test "the model refuses oversized files on any path" do
    photo = Photo.new(user: users(:camilo))
    photo.photo.attach(io: StringIO.new("x" * (Photo::MAX_UPLOAD_SIZE + 1)), filename: "big.jpg", content_type: "image/jpeg")
    assert_not photo.valid?
    assert_includes photo.errors[:photo].join, "3 MB"
  end

  test "editing a photo's text does not re-check its file" do
    photo = photos(:photo1)
    photo.photo.attach(io: StringIO.new("x" * 100), filename: "ok.jpg", content_type: "image/jpeg")
    photo.photo.blob.update_column(:byte_size, Photo::MAX_UPLOAD_SIZE + 1)
    photo = Photo.find(photo.id)
    assert photo.update(title: "renamed")
  end
end
