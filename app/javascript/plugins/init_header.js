
const initHeader = () => {

const body = document.body;
const triggerMenu = document.querySelector(".page-header .trigger-menu");
const nav = document.querySelector(".page-header nav");
const menu = document.querySelector(".page-header .menu");
const lottieWrapper = document.querySelector(".lottie-wrapper");
const lottiePlayer = document.querySelector("lottie-player");
const scrollUp = "scroll-up";
const scrollDown = "scroll-down";
let lastScroll = 0;

triggerMenu.addEventListener("click", () => {
  body.classList.toggle("menu-open");
});

// s

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