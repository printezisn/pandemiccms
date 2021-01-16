import initComponents from './components/initializer';

if (document.readyState === 'complete') {
  initComponents();
} else {
  document.addEventListener('DOMContentLoaded', () => {
    initComponents();
  });
}
