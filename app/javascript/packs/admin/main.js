import toastr from 'toastr';

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

const initFlashErrors = () => {
  [...document.getElementsByClassName('flash-error')].forEach((el) => {
    toastr.error(el.innerHTML);
  });
};

const initFlashSuccesses = () => {
  [...document.getElementsByClassName('flash-success')].forEach((el) => {
    toastr.success(el.innerHTML);
  });
};

const init = () => {
  initNavbars();
  initNotifications();
  initFlashErrors();
  initFlashSuccesses();
};

if (document.readyState === 'complete') {
  init();
} else {
  document.addEventListener('DOMContentLoaded', () => {
    init();
  });
}
