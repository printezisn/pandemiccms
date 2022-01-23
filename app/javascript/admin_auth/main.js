import './styles/main.scss';

import initComponents from '../admin/components/initializer';

if (document.readyState === 'complete') {
  initComponents();
} else {
  document.addEventListener('DOMContentLoaded', () => {
    initComponents();
  });
}
