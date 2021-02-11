import toastr from 'toastr';
import { initSmartTable, initSmartTableSearchForm } from './smart-table';
import initTabs from './tab';
import initDropdown from './dropdown';
import initImageUploader from './image-uploader';

const initNavbars = (root) => {
  Array.from(root.getElementsByClassName('navbar-burger')).forEach((el) => {
    const target = document.getElementById(el.getAttribute('data-target'));
    el.addEventListener('click', () => {
      target.classList.toggle('is-active');
    });
  });
};

const initNotifications = (root) => {
  Array.from(root.querySelectorAll('.notification > .delete')).forEach((el) => {
    el.addEventListener('click', () => {
      el.parentElement.remove();
    });
  });
};

const initFlashErrors = (root) => {
  Array.from(root.getElementsByClassName('flash-error')).forEach((el) => {
    toastr.error(el.innerHTML);
  });
};

const initFlashSuccesses = (root) => {
  Array.from(root.getElementsByClassName('flash-success')).forEach((el) => {
    toastr.success(el.innerHTML);
  });
};

const initCopyLinkButtons = (root) => {
  Array.from(root.getElementsByClassName('copy-link')).forEach((el) => {
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
  Array.from(root.querySelectorAll('[data-modal-open]')).forEach((el) => {
    el.addEventListener('click', () => {
      document.getElementById(el.getAttribute('data-modal-open')).classList.add('is-active');
    });
  });
};

const initModals = (root) => {
  Array.from(root.getElementsByClassName('modal')).forEach((modal) => {
    Array.from(modal.getElementsByClassName('cancel')).forEach((el) => {
      el.addEventListener('click', () => {
        modal.classList.remove('is-active');
      });
    });
  });
};

const initAutoSubmitInputs = (root) => {
  Array.from(root.getElementsByClassName('auto-submit')).forEach((el) => {
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

const initDropdowns = (root) => {
  Array.from(root.querySelectorAll('.dropdown.is-togglable')).forEach((el) => {
    initDropdown(el);
  });
};

const initSmartTableSearchForms = (root) => {
  Array.from(root.getElementsByClassName('smart-table-search')).forEach((el) => {
    initSmartTableSearchForm(el);
  });
};

const initSmartTables = (root) => {
  Array.from(root.getElementsByClassName('smart-table')).forEach((el) => {
    initSmartTable(el, () => {
      initModalOpeners(el);
      initModals(el);
      initCopyLinkButtons(el);
      initAutoSubmitInputs(el);
      initDropdowns(el);
      initSmartTableSearchForms(el);
    });
  });
};

const initTabWrappers = (root) => {
  Array.from(root.getElementsByClassName('tabs')).forEach((el) => initTabs(el));
};

const initImageUploaders = (root) => {
  Array.from(root.getElementsByClassName('image-uploader')).forEach((el) => initImageUploader(el));
};

const initRichEditors = (root) => {
  Array.from(root.getElementsByClassName('rich-editor')).forEach((el) => {
    import(/* webpackChunkName: 'rich-editor' */ './rich-editor').then(({ default: initRichEditor }) => {
      initRichEditor(el);
    });
  });
};

const initHistory = () => {
  window.addEventListener('popstate', () => {
    window.location.reload();
  });
};

const initAll = () => {
  initNavbars(document);
  initNotifications(document);
  initFlashErrors(document);
  initFlashSuccesses(document);
  initCopyLinkButtons(document);
  initModalOpeners(document);
  initModals(document);
  initAutoSubmitInputs(document);
  initDropdowns(document);
  initSmartTables(document);
  initSmartTableSearchForms(document);
  initTabWrappers(document);
  initImageUploaders(document);
  initRichEditors(document);

  initHistory();
};

export default initAll;
