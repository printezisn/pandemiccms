const loadLocales = async () => {
  const lang = document.documentElement.getAttribute('data-js-locale');
  const { default: locales } = await import(`./${lang}/app.js`);

  return locales;
};

export default loadLocales;
