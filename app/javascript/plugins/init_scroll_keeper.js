const scrollState = {}; // Local state to store scroll position

const initScrollKeeper = () => {
  prepareAnchorFormElements();
  prepareAnchorLinkElements();
};

const setScroll = () => {
  if (scrollState["top"]) {
    document.scrollingElement.scrollTo(0, scrollState["top"]);
  }

  scrollState["top"] = undefined; // Reset after scroll is restored
};

const prepareAnchorFormElements = () => {
  const anchorFormElements = document.querySelectorAll(".anchor-form");

  if (anchorFormElements.length > 0) {
    anchorFormElements.forEach((element) => {
      element.addEventListener("submit", () => {
        scrollState["top"] = document.scrollingElement.scrollTop;
      });
    });
    setScroll();
  }
};

const prepareAnchorLinkElements = () => {
  const anchorLinkElements = document.querySelectorAll(".anchor-link");

  if (anchorLinkElements.length > 0) {
    anchorLinkElements.forEach((element) => {
      element.addEventListener("click", () => {
        scrollState["top"] = document.scrollingElement.scrollTop;
      });
    });
    setScroll();
  }
};

export { initScrollKeeper };
