const initTabs = (tabs) => {
  const toggles = Array.from(tabs.querySelectorAll('[data-toggle]'));
  const contents = {};

  toggles.forEach((toggle) => {
    const ref = toggle.getAttribute('data-toggle');
    contents[ref] = document.getElementById(ref);

    toggle.addEventListener('click', () => {
      toggles.forEach((otherToggle) => otherToggle.parentElement.classList.remove('is-active'));
      Object.values(contents).forEach((content) => {
        const contentEl = content;
        contentEl.style.display = 'none';
      });

      toggle.parentElement.classList.add('is-active');
      contents[ref].style.display = '';
    });
  });
};

export default initTabs;
