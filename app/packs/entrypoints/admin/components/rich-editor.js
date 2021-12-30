import tinymce from 'tinymce';
import 'tinymce/icons/default';
import 'tinymce/themes/silver';

require.context(
  '!file-loader?name=[path][name].[ext]&context=node_modules/tinymce&outputPath=js!tinymce/skins',
  true,
  /.*/,
);
require.context(
  '!file-loader?name=[path][name].[ext]&context=node_modules/tinymce&outputPath=js!tinymce/plugins',
  true,
  /.*/,
);

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
