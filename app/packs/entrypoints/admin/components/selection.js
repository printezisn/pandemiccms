import $ from 'jquery';
import 'select2';
import '../styles/selection.scss';

const initSelection = (selection) => {
  $(selection).select2();
};

export default initSelection;
