import Quill from 'quill';
import Link from 'quill/formats/link';
import '../styles/admin/rich-editor.scss';

class MyLink extends Link {
  static create (value) {
    const node = super.create(value);
    value = this.sanitize(value);
    node.setAttribute('href', value);
    if (!value.startsWith('http://') && !value.startsWith('https://')) {
      node.removeAttribute('target');
      node.removeAttribute('rel');
    }

    return node;
  }
}

Quill.register(MyLink);

const toolbarOptions = [
  [{ header: [1, 2, 3, 4, 5, 6, false] }],
  ['bold', 'italic', 'underline', 'strike'],
  ['blockquote', 'code-block'],
  ['link', 'image', 'video'],
  [{ list: 'ordered' }, { list: 'bullet' }],
  [{ align: '' }, { align: 'center' }, { align: 'right' }, { align: 'justify' }],
  ['clean'],
];

const initRichEditor = (editor) => {
  editor.style.display = 'none';

  const id = `${editor.id}-container`;
  editor.insertAdjacentHTML('afterend', `<div id="${id}"></div>`);
  const quill = new Quill(`#${id}`, {
    modules: {
      toolbar: toolbarOptions,
    },
    theme: 'snow',
    readOnly: editor.hasAttribute('readonly'),
  });

  quill.clipboard.dangerouslyPasteHTML(editor.value || '');

  quill.getModule('toolbar').addHandler('image', () => {
    const input = document.createElement('input');
    input.setAttribute('type', 'file');
    input.setAttribute('accept', 'image/*');

    input.onchange = () => {
      const file = input.files[0];

      const xhr = new XMLHttpRequest();
      xhr.open('POST', '/admin/media.json');

      xhr.onload = () => {
        if (xhr.status !== 200) {
          throw new Error(`Cannot upload image. HTTP Error: ${xhr.status}`);
        }

        const json = JSON.parse(xhr.responseText);

        if (!json) {
          throw new Error(`Cannot upload image. Invalid JSON: ${xhr.responseText}`);
        }
        if (json.error) {
          throw new Error(`Cannot upload image. Server Error: ${json.error}`);
        }

        const range = quill.getSelection();
        quill.insertEmbed(range.index, 'image', json.url);
      };

      xhr.onerror = () => {
        throw new Error(`Cannot upload image due to a XHR Transport error. Code: ${xhr.status}`);
      };

      const formData = new FormData();
      formData.append(
        document.head.querySelector('meta[name="csrf-param"]').content,
        document.head.querySelector('meta[name="csrf-token"]').content,
      );
      formData.append('medium[file][]', file, file.name);

      xhr.send(formData);
    };

    input.click();
  });

  quill.clipboard.addMatcher(Node.ELEMENT_NODE, (node, delta) => {
    delta.ops.forEach(op => {
      if (op.attributes && op.attributes.background) {
        delete op.attributes.background;
      }
      if (op.attributes && op.attributes.color) {
        delete op.attributes.color;
      }
    });

    return delta;
  });

  quill.on('text-change', () => {
    editor.value = quill.getText().trim() !== ''
      ? quill.getSemanticHTML().replace(/&nbsp;/g, ' ')
      : '';
  });
};

export default initRichEditor;
