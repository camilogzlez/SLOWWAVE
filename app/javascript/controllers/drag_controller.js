import { Controller } from "@hotwired/stimulus";
import Sortable from "sortablejs";

export default class extends Controller {
  connect() {
    this.sortable = Sortable.create(this.element, {
      onEnd: this.end.bind(this)
    });
  }

  end(event) {
    console.log(event);
    // Additional logic to handle the reordering, such as sending an AJAX request to update the order in the database
  }
}


