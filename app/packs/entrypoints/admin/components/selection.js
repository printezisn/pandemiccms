import $ from 'jquery';
import 'select2';
import loadLocales from '../../locales';
import '../styles/selection.scss';

const initSelection = async (selection) => {
  const locales = await loadLocales();
  const options = {
    language: locales.select2,
  };

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
        term: params.term,
        page: params.page || 1,
      }),
    };
  }

  $(selection).select2(options);
};

export default initSelection;
