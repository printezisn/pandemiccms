import tinymce from 'tinymce';

import 'tinymce/icons/default';
import 'tinymce/themes/silver';

import 'tinymce/skins/ui/oxide/skin.css';

import 'tinymce/plugins/advlist';
import 'tinymce/plugins/autolink';
import 'tinymce/plugins/lists';
import 'tinymce/plugins/link';
import 'tinymce/plugins/image';
import 'tinymce/plugins/charmap';
import 'tinymce/plugins/print';
import 'tinymce/plugins/preview';
import 'tinymce/plugins/anchor';
import 'tinymce/plugins/searchreplace';
import 'tinymce/plugins/visualblocks';
import 'tinymce/plugins/code';
import 'tinymce/plugins/fullscreen';
import 'tinymce/plugins/insertdatetime';
import 'tinymce/plugins/media';
import 'tinymce/plugins/table';
import 'tinymce/plugins/paste';
import 'tinymce/plugins/wordcount';
import 'tinymce/plugins/help';
import 'tinymce/plugins/autoresize';

import contentUiCss from 'tinymce/skins/ui/oxide/content.css';
import contentCss from 'tinymce/skins/content/default/content.css';

tinymce.baseURL = '/assets/admin/components/rich-editor';

const initRichEditor = (editor) => {
  tinymce.init({
    selector: `#${editor.id}`,
    convert_urls: false,
    plugins: [
      'advlist autolink lists link image charmap print preview anchor',
      'searchreplace visualblocks code fullscreen',
      'insertdatetime media table paste code help wordcount autoresize code',
    ],
    toolbar: `undo redo | formatselect |
      bold italic forecolor | alignleft aligncenter
      alignright alignjustify | link image | bullist numlist outdent indent |
      code | removeformat fullscreen`,
    menubar: false,
    image_caption: true,
    min_height: 350,
    readonly: editor.hasAttribute('readonly') ? 1 : 0,
    skin: false,
    content_css: false,
    content_style: `${contentUiCss.toString()}\n${contentCss.toString()}`,
    images_upload_handler: (blobInfo, success, failure) => {
      const xhr = new XMLHttpRequest();
      xhr.open('POST', '/admin/media.json');

      xhr.onload = () => {
        if (xhr.status !== 200) {
          failure(`HTTP Error: ${xhr.status}`);
          return;
        }

        const json = JSON.parse(xhr.responseText);

        if (!json) {
          failure(`Invalid JSON: ${xhr.responseText}`);
          return;
        }
        if (json.error) {
          failure(json.error);
          return;
        }

        success(json.url);
      };

      const formData = new FormData();
      formData.append(
        document.head.querySelector('meta[name="csrf-param"]').content,
        document.head.querySelector('meta[name="csrf-token"]').content,
      );
      formData.append('medium[file][]', blobInfo.blob(), blobInfo.filename());

      xhr.send(formData);
    },
  });
};

export default initRichEditor;
