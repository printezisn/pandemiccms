const initNavbars = () => {
  [...document.getElementsByClassName('navbar-burger')].forEach((el) => {
    const target = document.getElementById(el.getAttribute('data-target'));
    el.addEventListener('click', () => {
      target.classList.toggle('is-active');
    });
  });
};

const initNotifications = () => {
  [...document.querySelectorAll('.notification > .delete')].forEach((el) => {
    el.addEventListener('click', () => {
      el.parentElement.remove();
    });
  });
};

const init = () => {
  initNavbars();
  initNotifications();
};

if (document.readyState === 'complete') {
  init();
} else {
  document.addEventListener('DOMContentLoaded', () => {
    init();
  });
}
