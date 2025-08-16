import '../../styles/admin_auth/main.scss';

import initComponents from '../../components/initializer';

if (document.readyState === 'complete') {
  initComponents();
} else {
  document.addEventListener('DOMContentLoaded', () => {
    initComponents();
  });
}

if ('serviceWorker' in navigator) {
  navigator.serviceWorker.register('/service-worker.js');
}
