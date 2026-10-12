// Grid thumbnails open a shared Bootstrap modal via data-bs-toggle/data-bs-target
// (see photos_by_category/photos_by_project/photos_by_subcategory views). Bootstrap
// passes the clicked thumbnail as event.relatedTarget on show.bs.modal, so we read
// its data-slide-to and jump the carousel straight to that photo by swapping the
// .active class directly -- a real "jump" with no slide-in animation, rather than
// animating through Bootstrap's Carousel#to() (which depends on measuring the
// carousel's width, unreliable while the modal is still becoming visible). Bootstrap's
// own data-api still auto-attaches to the indicator dots and prev/next controls from
// this resulting DOM state, so normal slide navigation keeps working untouched.
const initLightbox = () => {
  document.querySelectorAll(".lightbox-modal").forEach((modalEl) => {
    const carouselEl = modalEl.querySelector(".carousel");
    if (!carouselEl) return;

    const items = carouselEl.querySelectorAll(".carousel-item");
    const indicators = carouselEl.querySelectorAll(".carousel-indicators > button");

    modalEl.addEventListener("show.bs.modal", (event) => {
      const trigger = event.relatedTarget;
      const slideTo = trigger && trigger.dataset.slideTo;
      if (slideTo === undefined) return;

      const index = parseInt(slideTo, 10);
      items.forEach((item, i) => item.classList.toggle("active", i === index));
      indicators.forEach((indicator, i) => {
        indicator.classList.toggle("active", i === index);
        if (i === index) {
          indicator.setAttribute("aria-current", "true");
        } else {
          indicator.removeAttribute("aria-current");
        }
      });
    });
  });
};

export { initLightbox };
