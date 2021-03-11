import $ from 'jquery';
import 'select2';
import '../styles/selection.scss';

const initSelection = (selection) => {
  const options = {};

  const placeholder = selection.getAttribute('placeholder');
  if (placeholder) {
    options.placeholder = placeholder;
    options.allowClear = true;
  }

  const fetchUrl = selection.getAttribute('data-fetchUrl');
  if (fetchUrl) {
    options.ajax = {
      url: fetchUrl,
      data: (params) => ({
        search: params.term,
        page: params.page || 1,
      }),
    };
  }

  $(selection).select2(options);
};

export default initSelection;
