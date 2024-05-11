import $ from 'jquery';
import 'select2';

const initSelect2 = () => {
  const categoriesSelect = $('#categories-select');
  const projectsSelect = $('#projects-select');

  if (categoriesSelect.length) {
    categoriesSelect.select2();
  }

  if (projectsSelect.length) {
    projectsSelect.select2();
  }
};

export { initSelect2 };
