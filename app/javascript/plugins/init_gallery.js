import { Carousel } from "bootstrap";

// Category, subcategory and project pages open on the carousel, laid over a faded
// copy of the grid; the grid is one click away. Picking a grid thumbnail jumps the
// carousel to that photo by swapping the .active class directly (Bootstrap reads the
// active slide from the DOM, so its own controls keep working from there).
const initGallery = () => {
  // <html> survives Turbolinks visits, so clear the scroll lock from the last page.
  document.documentElement.classList.remove("gallery-carousel-open");

  document.querySelectorAll(".photo-gallery").forEach((gallery) => {
    const carouselEl = gallery.querySelector(".carousel");
    const items = carouselEl.querySelectorAll(".carousel-item");
    const counter = gallery.querySelector(".gallery-counter-current");

    // Only fetch the photos around the one on screen, so a visit doesn't
    // download the whole set from Cloudinary.
    const loadAround = (index) => {
      [index - 1, index, index + 1].forEach((i) => {
        const img = items[(i + items.length) % items.length]?.querySelector("img[loading='lazy']");
        if (img) img.loading = "eager";
      });
    };

    const showSlide = (index) => {
      items.forEach((item, i) => item.classList.toggle("active", i === index));
      counter.textContent = index + 1;
      loadAround(index);
    };

    const showView = (view) => {
      gallery.dataset.view = view;
      document.documentElement.classList.toggle("gallery-carousel-open", view === "carousel");
      const carousel = Carousel.getOrCreateInstance(carouselEl);
      view === "grid" ? carousel.pause() : carousel.cycle();
    };

    carouselEl.addEventListener("slide.bs.carousel", (event) => {
      counter.textContent = event.to + 1;
      loadAround(event.to);
    });

    // Left/right arrow keys page through the carousel while it is open; Escape shows the grid.
    document.addEventListener("keydown", (event) => {
      if (gallery.dataset.view !== "carousel" || !gallery.isConnected) return;
      if (event.target.closest("input, textarea, select")) return;
      const carousel = Carousel.getOrCreateInstance(carouselEl);
      if (event.key === "ArrowLeft") carousel.prev();
      if (event.key === "ArrowRight") carousel.next();
      if (event.key === "Escape") showView("grid");
    });

    gallery.querySelectorAll("[data-show-view]").forEach((button) => {
      button.addEventListener("click", () => showView(button.dataset.showView));
    });

    gallery.querySelectorAll("[data-slide-to]").forEach((thumb) => {
      thumb.addEventListener("click", () => {
        showSlide(parseInt(thumb.dataset.slideTo, 10));
        showView("carousel");
      });
    });

    showView(gallery.dataset.view);
  });
};

export { initGallery };
