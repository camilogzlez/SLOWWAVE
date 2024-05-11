
const initHeader = () => {

const body = document.body;
const triggerMenuCategories = document.querySelector(".page-header .trigger-menu-categories");
const triggerMenuProjects = document.querySelector(".page-header .trigger-menu-projects");
const lottiePlayer = document.querySelector("lottie-player");
const scrollUp = "scroll-up";
const scrollDown = "scroll-down";
let lastScroll = 0;

  triggerMenuCategories.addEventListener("click", () => {
    body.classList.toggle("menu-open-categories"); // Use a different class for categories
    body.classList.remove("menu-open-projects"); // Close projects menu
  });

  triggerMenuProjects.addEventListener("click", () => {
    body.classList.toggle("menu-open-projects"); // Use a different class for projects
    body.classList.remove("menu-open-categories"); // Close categories menu// Ensure the other SVG is closed
  });

window.addEventListener("scroll", () => {
  const currentScroll = window.pageYOffset;
  if (currentScroll <= 0) {
    body.classList.remove(scrollUp);
    return;
  }

  if (currentScroll > lastScroll && !body.classList.contains(scrollDown)) {
    // down
    body.classList.remove(scrollUp);
    body.classList.add(scrollDown);
    lottiePlayer.play();
  } else if (
    currentScroll < lastScroll &&
    body.classList.contains(scrollDown)
  ) {
    // up
    body.classList.remove(scrollDown);
    body.classList.add(scrollUp);
    lottiePlayer.stop();
  }
  lastScroll = currentScroll;
});

}

export { initHeader };
