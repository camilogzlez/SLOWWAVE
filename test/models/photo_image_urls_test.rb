require "test_helper"

class PhotoImageUrlsTest < ActiveSupport::TestCase
  setup do
    blob = ActiveStorage::Blob.new(key: "abc123", filename: "a.png", service_name: "cloudinary", byte_size: 1, checksum: "x", content_type: "image/png")
    @photo = Photo.new
    @photo.photo.attach(blob)
  end

  test "pages share the same transformations" do
    assert_includes @photo.thumbnail_url, "/c_fill,f_auto,h_600,q_auto,w_600/abc123"
    assert_includes @photo.full_url, "/c_limit,f_auto,q_auto,w_1200/abc123"
  end

  test "urls can be generated repeatedly" do
    assert_equal @photo.thumbnail_url, @photo.thumbnail_url
  end

  test "large home tiles get a wider image" do
    assert_includes @photo.home_url(3), "w_1000"
    assert_includes @photo.home_url(4), "w_1400"
  end
end
