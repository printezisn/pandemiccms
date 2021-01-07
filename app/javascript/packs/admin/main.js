import toastr from 'toastr';
import { initSmartTable, initSmartTableSearchForm } from './components/smart_table';
import initTabs from './components/tab';

const initNavbars = (root) => {
  [...root.getElementsByClassName('navbar-burger')].forEach((el) => {
    const target = document.getElementById(el.getAttribute('data-target'));
    el.addEventListener('click', () => {
      target.classList.toggle('is-active');
    });
  });
};

const initNotifications = (root) => {
  [...root.querySelectorAll('.notification > .delete')].forEach((el) => {
    el.addEventListener('click', () => {
      el.parentElement.remove();
    });
  });
};

const initFlashErrors = (root) => {
  [...root.getElementsByClassName('flash-error')].forEach((el) => {
    toastr.error(el.innerHTML);
  });
};

const initFlashSuccesses = (root) => {
  [...root.getElementsByClassName('flash-success')].forEach((el) => {
    toastr.success(el.innerHTML);
  });
};

const initCopyLinkButtons = (root) => {
  [...root.getElementsByClassName('copy-link')].forEach((el) => {
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

const initModalOpeners = (root) => {
  [...root.querySelectorAll('[data-modal-open]')].forEach((el) => {
    el.addEventListener('click', () => {
      document.getElementById(el.getAttribute('data-modal-open')).classList.add('is-active');
    });
  });
};

const initModals = (root) => {
  [...root.getElementsByClassName('modal')].forEach((modal) => {
    [...modal.getElementsByClassName('cancel')].forEach((el) => {
      el.addEventListener('click', () => {
        modal.classList.remove('is-active');
      });
    });
  });
};

const initAutoSubmitInputs = (root) => {
  [...root.getElementsByClassName('auto-submit')].forEach((el) => {
    el.addEventListener('change', () => {
      let current = el;

      while (current.parentElement) {
        if (current.parentElement.tagName === 'FORM') {
          current.parentElement.submit();
          break;
        }

        current = current.parentElement;
      }
    });
  });
};

const initSmartTableSearchForms = (root) => {
  [...root.getElementsByClassName('smart-table-search')].forEach((el) => {
    initSmartTableSearchForm(el);
  });
};

const initSmartTables = (root) => {
  [...root.getElementsByClassName('smart-table')].forEach((el) => {
    initSmartTable(el, () => {
      initModalOpeners(el);
      initModals(el);
      initCopyLinkButtons(el);
      initAutoSubmitInputs(el);
      initSmartTableSearchForms(el);
    });
  });
};

const initTabWrappers = (root) => {
  [...root.getElementsByClassName('tabs')].forEach((el) => initTabs(el));
};

const initHistory = () => {
  window.addEventListener('popstate', () => {
    window.location.reload();
  });
};

const init = () => {
  initNavbars(document);
  initNotifications(document);
  initFlashErrors(document);
  initFlashSuccesses(document);
  initCopyLinkButtons(document);
  initModalOpeners(document);
  initModals(document);
  initAutoSubmitInputs(document);
  initSmartTables(document);
  initSmartTableSearchForms(document);
  initTabWrappers(document);

  initHistory();
};

if (document.readyState === 'complete') {
  init();
} else {
  document.addEventListener('DOMContentLoaded', () => {
    init();
  });
}
