require "application_system_test_case"

class PhotoGalleryTest < ApplicationSystemTestCase
  PNG = Base64.decode64("iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==")

  setup do
    category = Category.create!(name: "Tango")
    @photos = [photos(:photo1), photos(:photo2)]
    @photos.each_with_index do |photo, n|
      photo.photo.attach(io: StringIO.new(PNG), filename: "p#{n}.png", content_type: "image/png")
      CategoryPhoto.create!(photo: photo, category: category)
    end
  end

  test "opens on the carousel, switches to the grid and back from a thumbnail" do
    visit photos_by_category_path(param: "Tango")

    assert_selector ".gallery-carousel-view .carousel-item.active"
    assert_selector ".gallery-counter", text: "1 / 2"

    find(".gallery-arrow--next").click
    wait_for_slide(1)
    assert_selector ".gallery-counter", text: "2 / 2"

    find(".gallery-view-toggle").click
    assert_no_selector ".gallery-carousel-view"
    assert_selector ".gallery-grid .gallery-container", count: 2

    all(".gallery-grid [data-slide-to]").first.click
    assert_selector ".gallery-carousel-view"
    assert_equal 0, active_slide
    assert_selector ".gallery-counter", text: "1 / 2"

    find("body").send_keys(:escape)
    assert_no_selector ".gallery-carousel-view"

    all(".gallery-grid [data-slide-to]").last.click
    find(".gallery-close").click
    assert_no_selector ".gallery-carousel-view"
  end

  test "the header stays visible when the carousel opens from further down the grid" do
    visit photos_by_category_path(param: "Tango")
    find(".gallery-view-toggle").click
    page.execute_script("document.body.classList.add('scroll-down')") # what the header script does on scroll

    all(".gallery-grid [data-slide-to]").last.click
    header_top = "document.querySelector('.trigger-menu-wrapper').getBoundingClientRect().top"
    wait_for { evaluate_script(header_top).zero? }
  end

  test "arrow keys and the sides of the photo page through, and it plays by itself" do
    visit photos_by_category_path(param: "Tango")
    assert_equal 0, active_slide

    find("body").send_keys(:right)
    wait_for_slide(1)

    find(".gallery-side--prev").click
    wait_for_slide(0)

    find(".gallery-side--next").click
    wait_for_slide(1)

    wait_for(timeout: 8) { active_slide == 0 }
  end

  private

  def active_slide
    all(".carousel-item", visible: :all).index { |item| item[:class].to_s.split.include?("active") }
  end

  # Bootstrap ignores clicks while a slide is still animating.
  def wait_for_slide(index)
    wait_for { active_slide == index && !page.has_css?(".carousel-item-start, .carousel-item-end", wait: 0) }
  end

  def wait_for(timeout: 5)
    deadline = Time.current + timeout
    until yield
      flunk "condition not met in time" if Time.current > deadline
      sleep 0.1
    end
  end
end
