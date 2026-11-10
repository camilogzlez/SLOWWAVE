document.addEventListener("DOMContentLoaded", function () {
  var layout = document.querySelector(".hg-layout");
  if (!layout) return;

  // The preview mimics the public grid at this screen width.
  var DESKTOP_WIDTH = 1440;

  var grid = document.getElementById("home-grid");
  var pool = document.getElementById("home-pool");
  var status = document.querySelector(".hg-status");

  var dragged = null;
  var draggedPhotoId = null;
  var placeholder = null;
  var originalNext = null;
  var dropped = false;

  function updateScale() {
    grid.style.setProperty("--hg-scale", grid.clientWidth / DESKTOP_WIDTH);
  }
  updateScale();
  window.addEventListener("resize", updateScale);

  function request(url, method, body, accept) {
    var csrfMeta = document.querySelector('meta[name="csrf-token"]');
    return fetch(url, {
      method: method,
      headers: {
        "Content-Type": "application/json",
        "Accept": accept || "application/json",
        "X-CSRF-Token": csrfMeta ? csrfMeta.content : ""
      },
      body: body ? JSON.stringify(body) : undefined
    }).then(function (response) {
      if (response.ok) return response;
      return response.text().then(function (text) { throw new Error(text || "Request failed"); });
    });
  }

  function showStatus(text, isError) {
    status.textContent = text;
    status.classList.toggle("save-status--error", !!isError);
    if (!isError) setTimeout(function () { status.textContent = ""; }, 1500);
  }

  function showError() {
    showStatus("Error saving. Reload the page and try again.", true);
  }

  function elementFromHtml(html) {
    var wrapper = document.createElement("div");
    wrapper.innerHTML = html.trim();
    return wrapper.firstElementChild;
  }

  function persistOrder() {
    var order = Array.prototype.map.call(grid.querySelectorAll(".hg-tile[data-id]"), function (tile) {
      return tile.dataset.id;
    });
    return request(layout.dataset.reorderUrl, "PATCH", { order: order })
      .then(function () { showStatus("Saved"); })
      .catch(showError);
  }

  function addPhoto(poolItem, slot) {
    request(layout.dataset.createUrl, "POST", { photo_id: poolItem.dataset.photoId }, "text/html")
      .then(function (response) { return response.text(); })
      .then(function (html) {
        var tile = elementFromHtml(html);
        if (slot && slot.parentNode) {
          slot.parentNode.replaceChild(tile, slot);
        } else {
          grid.appendChild(tile);
        }
        poolItem.remove();
        return persistOrder();
      })
      .catch(function () {
        if (slot) slot.remove();
        showError();
      });
  }

  // --- dragging photos in from the list ---

  pool.addEventListener("dragstart", function (e) {
    var item = e.target.closest(".hg-pool-item");
    if (!item) return;
    draggedPhotoId = item.dataset.photoId;
    dropped = false;
    e.dataTransfer.effectAllowed = "copy";
    e.dataTransfer.setData("text/plain", draggedPhotoId);
  });

  pool.addEventListener("click", function (e) {
    if (e.target.closest(".hg-add")) addPhoto(e.target.closest(".hg-pool-item"));
  });

  // --- dragging tiles around the grid ---

  grid.addEventListener("dragstart", function (e) {
    if (e.target.closest("select, button, label")) {
      e.preventDefault();
      return;
    }
    dragged = e.target.closest(".hg-tile");
    if (!dragged) return;
    originalNext = dragged.nextElementSibling;
    dropped = false;
    e.dataTransfer.effectAllowed = "move";
    e.dataTransfer.setData("text/plain", dragged.dataset.id);
    dragged.classList.add("hg-tile--dragging");
  });

  grid.addEventListener("dragover", function (e) {
    var moving = dragged || slotForPoolDrag();
    if (!moving) return;

    e.preventDefault();
    var target = e.target.closest(".hg-tile");

    if (!target) {
      if (!moving.parentNode) grid.appendChild(moving);
      return;
    }
    if (target === moving) return;

    var rect = target.getBoundingClientRect();
    var after = (e.clientX - rect.left) > rect.width / 2;
    grid.insertBefore(moving, after ? target.nextSibling : target);
  });

  function slotForPoolDrag() {
    if (!draggedPhotoId) return null;
    if (!placeholder) {
      placeholder = document.createElement("div");
      placeholder.className = "hg-tile hg-tile--placeholder";
      placeholder.style.gridColumn = "span 3";
      placeholder.style.gridRow = "span 3";
    }
    return placeholder;
  }

  grid.addEventListener("drop", function (e) {
    e.preventDefault();
    dropped = true;

    if (dragged) {
      persistOrder();
    } else if (draggedPhotoId) {
      var slot = slotForPoolDrag();
      if (!slot.parentNode) grid.appendChild(slot);
      addPhoto(pool.querySelector('[data-photo-id="' + draggedPhotoId + '"]'), slot);
      placeholder = null;
    }
  });

  document.addEventListener("dragend", function () {
    if (dragged) {
      dragged.classList.remove("hg-tile--dragging");
      if (!dropped) grid.insertBefore(dragged, originalNext);
    }
    if (placeholder) placeholder.remove();
    dragged = null;
    draggedPhotoId = null;
    placeholder = null;
    originalNext = null;
  });

  // --- tile controls ---

  grid.addEventListener("change", function (e) {
    var tile = e.target.closest(".hg-tile");
    if (!tile) return;

    var columnSpan = tile.querySelector(".hg-column-span").value;
    var rowSpan = tile.querySelector(".hg-row-span").value;
    tile.style.gridColumn = "span " + columnSpan;
    tile.style.gridRow = "span " + rowSpan;

    request(tile.dataset.url, "PATCH", { column_span: columnSpan, row_span: rowSpan })
      .then(function (response) { return response.json(); })
      .then(function (data) {
        var image = tile.querySelector("img");
        if (image.getAttribute("src") !== data.image_url) image.src = data.image_url;
        showStatus("Saved");
      })
      .catch(showError);
  });

  grid.addEventListener("click", function (e) {
    if (!e.target.closest(".hg-remove")) return;

    var tile = e.target.closest(".hg-tile");
    request(tile.dataset.url, "DELETE", null, "text/html")
      .then(function (response) { return response.text(); })
      .then(function (html) {
        tile.remove();
        pool.insertBefore(elementFromHtml(html), pool.firstChild);
        showStatus("Saved");
      })
      .catch(showError);
  });
});
