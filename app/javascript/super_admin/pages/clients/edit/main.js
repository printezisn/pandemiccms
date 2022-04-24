const initDeleteDomainButton = (button) => {
  button.addEventListener('click', () => {
    let current = button.parentElement;

    while (current && current.tagName !== 'TR') {
      current = current.parentElement;
    }

    if (current) {
      current.remove();
    }
  });
};

const initDomainsAndPorts = () => {
  const domainsContainer = document.getElementById('domains-container');
  const addDomainButton = document.getElementById('add-domain-button');

  Array.from(document.getElementsByClassName('delete-domain-button')).forEach(
    initDeleteDomainButton,
  );

  addDomainButton.addEventListener('click', () => {
    const newElementHTML = `
      <tr>
        <td>
          <input type="text" name="form_client[domains][]" class="input min-width-input" placeholder="localhost" />
        </td>
        <td>
          <input type="text" name="form_client[ports][]" class="input min-width-input" placeholder="3000" />
        </td>
        <td class="actions-cell">
          <button type="button" class="button is-danger delete-domain-button">
            <i class="fas fa-trash"></i>
          </button>
        </td>
      </tr>
    `;
    const entries = domainsContainer.querySelectorAll('tr');

    if (entries.length) {
      const lastEntry = entries[entries.length - 1];
      lastEntry.insertAdjacentHTML('afterend', newElementHTML);
    } else {
      domainsContainer.innerHTML = newElementHTML;
    }

    const deleteDomainButtons = Array.from(
      document.getElementsByClassName('delete-domain-button'),
    );
    const lastDeleteDomainButton = deleteDomainButtons[deleteDomainButtons.length - 1];

    initDeleteDomainButton(lastDeleteDomainButton);
  });
};

const initLanguageSelectors = () => {
  const checkboxes = Array.from(
    document.querySelectorAll('[name="form_client[language_ids][]"]'),
  );
  checkboxes.forEach((checkbox) => {
    checkbox.addEventListener('change', () => {
      if (checkbox.checked) {
        document
          .getElementById(`default-language-${checkbox.value}`)
          .classList.remove('is-hidden');
        if (
          checkboxes.filter((otherCheckbox) => otherCheckbox.checked).length > 1
        ) {
          document
            .getElementById('default-languages')
            .classList.remove('is-hidden');
        }
      } else {
        document
          .getElementById(`default-language-${checkbox.value}`)
          .classList.add('is-hidden');
        if (
          checkboxes.filter((otherCheckbox) => otherCheckbox.checked).length
          <= 1
        ) {
          document
            .getElementById('default-languages')
            .classList.add('is-hidden');
        }
      }
    });
  });
};

const init = () => {
  initDomainsAndPorts();
  initLanguageSelectors();
};

if (document.readyState === 'complete') {
  init();
} else {
  document.addEventListener('DOMContentLoaded', () => {
    init();
  });
}
