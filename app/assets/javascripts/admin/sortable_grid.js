document.addEventListener("DOMContentLoaded", function () {
  document.querySelectorAll(".sortable-grid").forEach(function (grid) {
    var dragged = null;

    grid.addEventListener("dragstart", function (e) {
      var interactive = e.target.closest(
        "input, textarea, select, button, a, label, .photo-card-fieldset"
      );
      if (interactive) {
        e.preventDefault();
        return;
      }

      dragged = e.target.closest(".sortable-item");
      if (!dragged) {
        e.preventDefault();
        return;
      }
      e.dataTransfer.effectAllowed = "move";
    });

    grid.addEventListener("dragover", function (e) {
      e.preventDefault();
      var target = e.target.closest(".sortable-item");
      if (!target || target === dragged) return;

      var rect = target.getBoundingClientRect();
      var after = (e.clientX - rect.left) > rect.width / 2;
      grid.insertBefore(dragged, after ? target.nextSibling : target);
    });

    grid.addEventListener("drop", function (e) {
      e.preventDefault();
      persistOrder(grid);
    });
  });

  function persistOrder(grid) {
    var order = Array.prototype.map.call(
      grid.querySelectorAll(".sortable-item"),
      function (el) { return el.dataset.id; }
    );

    var csrfMeta = document.querySelector('meta[name="csrf-token"]');

    fetch(grid.dataset.reorderUrl, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-CSRF-Token": csrfMeta ? csrfMeta.content : ""
      },
      body: JSON.stringify({ order: order })
    }).catch(function (err) {
      console.error("Failed to save new order", err);
    });
  }
});
