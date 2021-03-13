const loadLocales = async () => {
  const { lang } = document.documentElement;
  const { default: locales } = await import(/* webpackChunkName: 'locales' */ `./${lang}/app`);

  return locales;
};

export default loadLocales;
