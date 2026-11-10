document.addEventListener("DOMContentLoaded", function () {
  var toolbar = document.querySelector(".bulk-toolbar");
  if (!toolbar) return;

  var checkboxes = document.querySelectorAll(".pc-select-checkbox");
  var categorySelect = toolbar.querySelector(".bulk-category");
  var subcategorySelect = toolbar.querySelector(".bulk-subcategory");
  var projectSelect = toolbar.querySelector(".bulk-project");
  var error = toolbar.querySelector(".bulk-error");

  function selectedIds() {
    return Array.prototype.filter.call(checkboxes, function (checkbox) {
      return checkbox.checked;
    }).map(function (checkbox) {
      return checkbox.value;
    });
  }

  function refresh() {
    var count = selectedIds().length;
    toolbar.hidden = count === 0;
    toolbar.querySelector(".bulk-count").textContent = count;
    checkboxes.forEach(function (checkbox) {
      checkbox.closest(".photo-card").classList.toggle("photo-card--selected", checkbox.checked);
    });
  }

  function setAll(checked) {
    checkboxes.forEach(function (checkbox) { checkbox.checked = checked; });
    refresh();
  }

  function submit(url, method, payload) {
    var csrfMeta = document.querySelector('meta[name="csrf-token"]');
    payload.photo_ids = selectedIds();
    error.textContent = "";

    fetch(url, {
      method: method,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-CSRF-Token": csrfMeta ? csrfMeta.content : ""
      },
      body: JSON.stringify(payload)
    })
      .then(function (response) {
        return response.json().then(function (data) {
          if (!response.ok) throw new Error(data.error);
          window.location.reload();
        });
      })
      .catch(function (e) {
        error.textContent = "Error: " + e.message;
      });
  }

  checkboxes.forEach(function (checkbox) {
    checkbox.addEventListener("change", refresh);
  });
  refresh();

  toolbar.querySelector(".bulk-select-all").addEventListener("click", function () { setAll(true); });
  toolbar.querySelector(".bulk-clear").addEventListener("click", function () { setAll(false); });

  categorySelect.addEventListener("change", function () {
    var available = 0;
    subcategorySelect.value = "";
    Array.prototype.forEach.call(subcategorySelect.options, function (option) {
      if (!option.value) return;
      var matches = option.dataset.categoryId === categorySelect.value;
      option.hidden = !matches;
      option.disabled = !matches;
      if (matches) available += 1;
    });
    subcategorySelect.hidden = available === 0;
  });

  toolbar.querySelector(".bulk-add-category").addEventListener("click", function () {
    if (!categorySelect.value) {
      error.textContent = "Choose a category first.";
      return;
    }
    submit(toolbar.dataset.assignUrl, "POST", {
      category_id: categorySelect.value,
      subcategory_id: subcategorySelect.value
    });
  });

  toolbar.querySelector(".bulk-add-project").addEventListener("click", function () {
    if (!projectSelect.value) {
      error.textContent = "Choose a project first.";
      return;
    }
    submit(toolbar.dataset.assignUrl, "POST", { project_id: projectSelect.value });
  });

  toolbar.querySelector(".bulk-delete").addEventListener("click", function () {
    var count = selectedIds().length;
    var message = "Permanently delete " + count + " photo(s)? They will be removed from every category, " +
      "project and the home page, and their files will be deleted from Cloudinary. This cannot be undone.";
    if (window.confirm(message)) submit(toolbar.dataset.destroyUrl, "DELETE", {});
  });
});
