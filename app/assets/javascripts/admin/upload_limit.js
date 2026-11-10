document.addEventListener("DOMContentLoaded", function () {
  var input = document.getElementById("upload-files");
  if (!input) return;

  var submit = document.getElementById("upload-submit");
  var error = document.querySelector(".upload-size-error");
  var maxSize = Number(input.dataset.maxSize);

  input.addEventListener("change", function () {
    var tooBig = Array.prototype.filter.call(input.files, function (file) {
      return file.size > maxSize;
    }).map(function (file) {
      return file.name;
    });

    submit.disabled = tooBig.length > 0;
    error.textContent = tooBig.length === 0 ? "" :
      "Over " + input.dataset.sizeLabel + ", export these smaller first: " + tooBig.join(", ");
  });
});
