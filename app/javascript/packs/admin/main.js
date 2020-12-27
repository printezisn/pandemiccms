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

const initCopyLinkButtons = () => {
  [...document.getElementsByClassName('copy-link')].forEach((el) => {
    el.addEventListener('click', () => {
      const textarea = document.createElement('textarea');
      textarea.style.display = 'hidden';
      textarea.value = el.getAttribute('data-link');

      document.body.appendChild(textarea);
      textarea.select();
      document.execCommand('copy');
      document.body.removeChild(textarea);

      toastr.success(el.getAttribute('data-success-message'));
    });
  });
};

const init = () => {
  initNavbars();
  initNotifications();
  initFlashErrors();
  initFlashSuccesses();
  initCopyLinkButtons();
};

if (document.readyState === 'complete') {
  init();
} else {
  document.addEventListener('DOMContentLoaded', () => {
    init();
  });
}
