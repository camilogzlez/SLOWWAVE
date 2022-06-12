import $ from 'jquery';
import 'select2';

const initSelect2 = (value) => {
    if (value) {
      const link = document.querySelector('#js-example-basic-multiple');
      link.click();
  }
  $('#js-example-basic-multiple').select2();
};

export { initSelect2 };