const disableLinkableFormElement = (radio) => {
  const formElement = radio.parentElement.nextElementSibling;

  formElement.style.display = 'none';
  Array.from(formElement.querySelectorAll('[name]')).forEach((input) => input.setAttribute('disabled', 'disabled'));
};

const enableLinkableFormElement = (radio) => {
  const formElement = radio.parentElement.nextElementSibling;

  formElement.style.display = '';
  Array.from(formElement.querySelectorAll('[name]')).forEach((input) => input.removeAttribute('disabled'));
};

const initLinkableRadios = () => {
  const allRadios = Array.from(document.querySelectorAll('[type="radio"]'));
  allRadios.forEach((radio) => disableLinkableFormElement(radio));

  allRadios.forEach((radio) => {
    radio.addEventListener('change', () => {
      allRadios.forEach((otherRadio) => disableLinkableFormElement(otherRadio));
      enableLinkableFormElement(radio);
    });

    if (radio.checked) {
      enableLinkableFormElement(radio);
    }
  });
};

const init = () => {
  initLinkableRadios();
};

if (document.readyState === 'complete') {
  init();
} else {
  document.addEventListener('DOMContentLoaded', () => {
    init();
  });
}
