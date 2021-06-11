const initScrollKeeper = () => {
  prepareAnchorFormElements();
  prepareAnchorLinkElements();
};

const setScroll = () => {
  if (Turbolinks.scroll["top"]) {
    document.scrollingElement.scrollTo(0, Turbolinks.scroll["top"]);
  }

  Turbolinks.scroll = {};
};

const prepareAnchorFormElements = () => {
  const anchorFormElements = document.querySelectorAll(".anchor-form");

  if (anchorFormElements) {
    anchorFormElements.forEach((element) => {
      element.addEventListener("submit", () => {
        Turbolinks.scroll["top"] = document.scrollingElement.scrollTop;
      });
    });
    setScroll();
  };
};

const prepareAnchorLinkElements = () => {
  const anchorLinkElements = document.querySelectorAll(".anchor-link");

  if (anchorLinkElements) {
    anchorLinkElements.forEach((element) => {
      element.addEventListener("click", () => {
        Turbolinks.scroll["top"] = document.scrollingElement.scrollTop;
      });
    });
    setScroll();
  };
};

export { initScrollKeeper };