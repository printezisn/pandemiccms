import { initAll } from '../admin/components/initializers';

if (document.readyState === 'complete') {
  initAll();
} else {
  document.addEventListener('DOMContentLoaded', () => {
    initAll();
  });
}
