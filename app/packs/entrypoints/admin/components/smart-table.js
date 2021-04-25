const initLinks = (table) => {
  Array.from(table.querySelectorAll('th a, .filters a, .pagination a')).forEach((el) => {
    el.addEventListener('click', (e) => {
      e.preventDefault();
      table.dispatchEvent(new CustomEvent('refresh', {
        detail: {
          url: el.getAttribute('href'),
          updateHistory: true,
        },
      }));
    });
  });
};

export const initSmartTable = (table, refreshCallback) => {
  const tableEl = table;
  const useHistory = table.getAttribute('data-use-history') === 'true';

  if (useHistory) {
    window.addEventListener('popstate', (e) => {
      const { state } = e;

      if (state && state.smartTable) {
        e.stopImmediatePropagation();
        table.dispatchEvent(new CustomEvent('refresh', {
          detail: {
            url: state.url,
            updateHistory: false,
          },
        }));
      }
    });
  }

  table.addEventListener('refresh', ({ detail }) => {
    const { url, updateHistory } = detail;
    if (useHistory && updateHistory) {
      window.history.pushState({ smartTable: true, url }, document.title, url);
    }

    fetch(url, {
      headers: {
        'X-Requested-With': 'XMLHttpRequest',
      },
    }).then((response) => response.text()).then((html) => {
      tableEl.innerHTML = html;
      initLinks(tableEl);

      if (typeof refreshCallback === 'function') {
        refreshCallback();
      }
    });
  });

  initLinks(tableEl);

  if (tableEl.getAttribute('data-autoload')) {
    tableEl.dispatchEvent(new CustomEvent('refresh', {
      detail: {
        url: tableEl.getAttribute('data-autoload'),
        updateHistory: true,
      },
    }));
  }
};

export const initSmartTableSearchForm = (form) => {
  form.addEventListener('submit', (e) => {
    e.preventDefault();

    const queryString = Array.from(form.querySelectorAll('input, textarea, select'))
      .map((input) => `${input.name}=${encodeURIComponent(input.value)}`)
      .join('&');
    const url = `${form.getAttribute('action')}?${queryString}`;
    const target = document.getElementById(form.getAttribute('data-target'));

    target.dispatchEvent(new CustomEvent('refresh', {
      detail: {
        url,
        updateHistory: true,
      },
    }));
  });
};
