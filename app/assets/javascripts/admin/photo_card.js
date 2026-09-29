document.addEventListener("DOMContentLoaded", function () {
  document.querySelectorAll(".photo-card").forEach(function (card) {
    initCategoryToggles(card);
    initCollapsibleFields(card);

    var fields = card.querySelectorAll(
      ".pc-title, .pc-description, .pc-location, " +
      ".pc-category-checkbox, .pc-subcategory-select, .pc-project-checkbox"
    );

    fields.forEach(function (field) {
      field.addEventListener("change", function (e) {
        if (e.target.classList.contains("pc-category-checkbox")) {
          toggleSubcategorySelect(e.target);
        }
        saveCard(card);
      });
    });
  });

  function initCategoryToggles(card) {
    card.querySelectorAll(".pc-category-checkbox").forEach(function (checkbox) {
      toggleSubcategorySelect(checkbox);
    });
  }

  function toggleSubcategorySelect(checkbox) {
    var row = checkbox.closest(".pc-category-row");
    if (!row) return;
    var select = row.querySelector(".pc-subcategory-select");
    if (!select) return;
    select.hidden = !checkbox.checked;
  }

  function initCollapsibleFields(card) {
    card.querySelectorAll(".pc-collapsible").forEach(function (wrapper) {
      var btn = wrapper.querySelector(".pc-toggle-btn");
      var field = wrapper.querySelector(".pc-collapsible-field");
      if (!btn || !field) return;

      btn.addEventListener("click", function () {
        btn.hidden = true;
        field.hidden = false;
        var input = field.querySelector("input, textarea");
        if (input) input.focus();
      });

      var input = field.querySelector("input, textarea");
      if (!input) return;

      input.addEventListener("blur", function () {
        if (!input.value.trim()) {
          field.hidden = true;
          btn.hidden = false;
        }
      });
    });
  }

  function saveCard(card) {
    var status = card.querySelector(".save-status");
    var payload = {
      title: valueOf(card, ".pc-title"),
      description: valueOf(card, ".pc-description"),
      location: valueOf(card, ".pc-location"),
      category_ids: [],
      subcategory_by_category: {},
      project_ids: []
    };

    card.querySelectorAll(".pc-category-checkbox:checked").forEach(function (checkbox) {
      payload.category_ids.push(checkbox.value);

      var row = checkbox.closest(".pc-category-row");
      var select = row ? row.querySelector(".pc-subcategory-select") : null;
      if (select && !select.hidden && select.value) {
        payload.subcategory_by_category[checkbox.value] = select.value;
      }
    });

    card.querySelectorAll(".pc-project-checkbox:checked").forEach(function (checkbox) {
      payload.project_ids.push(checkbox.value);
    });

    if (status) status.textContent = "Saving…";

    var csrfMeta = document.querySelector('meta[name="csrf-token"]');

    fetch(card.dataset.updateUrl, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-CSRF-Token": csrfMeta ? csrfMeta.content : ""
      },
      body: JSON.stringify(payload)
    })
      .then(function (response) {
        return response.json().then(function (data) {
          return { ok: response.ok, data: data };
        });
      })
      .then(function (result) {
        if (!status) return;
        if (result.ok && result.data.ok) {
          status.textContent = "Saved";
          status.classList.remove("save-status--error");
          setTimeout(function () { status.textContent = ""; }, 1500);
        } else {
          status.textContent = "Error saving" + (result.data.error ? ": " + result.data.error : "");
          status.classList.add("save-status--error");
        }
      })
      .catch(function () {
        if (status) {
          status.textContent = "Error saving";
          status.classList.add("save-status--error");
        }
      });
  }

  function valueOf(card, selector) {
    var el = card.querySelector(selector);
    return el ? el.value : "";
  }
});
