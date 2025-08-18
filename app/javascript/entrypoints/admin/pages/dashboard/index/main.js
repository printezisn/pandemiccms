import { Chart } from 'chart.js/auto';

let chart;

const renderChart = (chartData) => {
  if (!chart) {
    const chartEl = document.getElementById('page-visits-chart');
    chartEl.style.maxHeight = '500px';
    const config = {
      type: 'line',
      data: {
        labels: Object.keys(chartData),
        datasets: [{
          data: Object.values(chartData),
          label: chartEl.getAttribute('data-label'),
        }],
      },
      options: {
        scales: {
          y: {
            beginAtZero: true,
            ticks: {
              stepSize: 1,
              callback: function (value) {
                if (Number.isInteger(value)) {
                  return value;
                }
              }
            }
          }
        }
      }

    };

    chart = new Chart(chartEl, config);
  } else {
    chart.data.labels = Object.keys(chartData);
    chart.data.datasets[0].data = Object.values(chartData);
    chart.update();
  }
};

const init = () => {
  let currentChartData = document.querySelector('[data-chart-data]')?.getAttribute('data-chart-data') || '{}';

  const observer = new MutationObserver((mutations) => {
    const newChartData = document.querySelector('[data-chart-data]')?.getAttribute('data-chart-data') || '{}';
    if (currentChartData === newChartData) return;

    currentChartData = newChartData;
    renderChart(JSON.parse(currentChartData));
  });

  observer.observe(document.getElementById('page-visits-smart-table'), { childList: true, subtree: true });
};

if (document.readyState === 'complete') {
  init();
} else {
  document.addEventListener('DOMContentLoaded', () => {
    init();
  });
};
