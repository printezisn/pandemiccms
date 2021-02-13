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
      'insertdatetime media table paste code help wordcount autoresize',
    ],
    toolbar: `undo redo | formatselect |
      bold italic forecolor | alignleft aligncenter
      alignright alignjustify | link image | bullist numlist outdent indent |
      removeformat fullscreen`,
    menubar: false,
    readonly: editor.hasAttribute('readonly') ? 1 : 0,
  });
};

export default initRichEditor;
