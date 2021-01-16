import { initAll } from './components/initializers';

if (document.readyState === 'complete') {
  initAll();
} else {
  document.addEventListener('DOMContentLoaded', () => {
    initAll();
  });
}
