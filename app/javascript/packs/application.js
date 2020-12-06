const initNavbars = () => {
  [...document.getElementsByClassName('navbar-burger')].forEach((el) => {
    const target = document.getElementById(el.getAttribute('data-target'));
    el.addEventListener('click', () => {
      target.classList.toggle('is-active');
    });
  });
};

const init = () => {
  initNavbars();
};

if (document.readyState === 'complete') {
  init();
} else {
  document.addEventListener('DOMContentLoaded', () => {
    init();
  });
}
