document.addEventListener("DOMContentLoaded", function () {
  document.querySelectorAll(".subcategory-card").forEach(function (card) {
    var nameField = card.querySelector(".sc-name");
    if (!nameField) return;

    nameField.addEventListener("change", function () {
      saveCard(card, nameField.value);
    });
  });

  function saveCard(card, name) {
    var status = card.querySelector(".save-status");
    if (status) status.textContent = "Saving…";

    var csrfMeta = document.querySelector('meta[name="csrf-token"]');

    fetch(card.dataset.updateUrl, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-CSRF-Token": csrfMeta ? csrfMeta.content : ""
      },
      body: JSON.stringify({ name: name })
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
});
