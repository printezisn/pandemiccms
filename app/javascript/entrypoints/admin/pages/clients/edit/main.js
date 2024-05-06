const initLanguageSelectors = () => {
  const checkboxes = Array.from(document.querySelectorAll('[name="language_ids[]"]'));
  checkboxes.forEach((checkbox) => {
    checkbox.addEventListener('change', () => {
      if (checkbox.checked) {
        document.getElementById(`default-language-${checkbox.value}`).classList.remove('is-hidden');
        if (checkboxes.filter((otherCheckbox) => otherCheckbox.checked).length > 1) {
          document.getElementById('default-languages').classList.remove('is-hidden');
        }
      } else {
        document.getElementById(`default-language-${checkbox.value}`).classList.add('is-hidden');
        if (checkboxes.filter((otherCheckbox) => otherCheckbox.checked).length <= 1) {
          document.getElementById('default-languages').classList.add('is-hidden');
        }
      }
    });
  });
};

const initCacheSettings = () => {
  const cacheEnabled = document.getElementById('client_cache_enabled');
  const cacheSettings = document.getElementById('cache-settings');

  cacheEnabled.addEventListener('change', () => {
    if (cacheEnabled.checked) {
      cacheSettings.classList.remove('is-hidden');
    } else {
      cacheSettings.classList.add('is-hidden');
    }
  });
};

const init = () => {
  initLanguageSelectors();
  initCacheSettings();
};

if (document.readyState === 'complete') {
  init();
} else {
  document.addEventListener('DOMContentLoaded', () => {
    init();
  });
}
