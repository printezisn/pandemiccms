import '../../../styles/templates/sample/main.scss';

const initNavbars = () => {
  Array.from(document.getElementsByClassName('navbar-burger')).forEach((el) => {
    const target = document.getElementById(el.getAttribute('data-target'));
    el.addEventListener('click', () => {
      target.classList.toggle('is-active');
    });
  });
};

const initParentFormSubmits = () => {
  Array.from(document.getElementsByClassName('submit-parent-form')).forEach((el) => {
    el.addEventListener('click', () => {
      el.parentElement.submit();
    });
  });
};

const init = () => {
  initNavbars();
  initParentFormSubmits();
};

if (document.readyState === 'complete') {
  init();
} else {
  document.addEventListener('DOMContentLoaded', () => {
    init();
  });
}

fetch(
  '/analytics/track_visit',
  {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      [document.querySelector('meta[name="csrf-param"]').content]: document.querySelector('meta[name="csrf-token"]').content,
      path: window.location.pathname + window.location.search,
    }),
  }
);

if ('serviceWorker' in navigator) {
  navigator.serviceWorker.register('/service-worker.js');
}
