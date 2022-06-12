// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction
// 
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { Controller } from "@hotwired/stimulus";
import $ from "jquery";
import "select2";
// import 'select2/dist/css/select2.min.css'; <- Uncomment this line if you are using Rails

export default class extends Controller {
  connect() {
     $(this.element).select2();
  }
}