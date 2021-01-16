const initDropdown = (dropdown) => {
  [...dropdown.querySelectorAll('.dropdown-trigger')].forEach((button) => {
    button.addEventListener('click', () => {
      dropdown.classList.toggle('is-active');
      dropdown.setAttribute('data-was-clicked', 'true');
    });
  });

  dropdown.addEventListener('click', () => dropdown.setAttribute('data-was-clicked', 'true'));
  document.addEventListener('click', () => {
    if (dropdown.getAttribute('data-was-clicked')) {
      dropdown.removeAttribute('data-was-clicked');
    } else {
      dropdown.classList.remove('is-active');
    }
  });
};

export default initDropdown;
