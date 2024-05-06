const initImageUploader = (uploader) => {
  const img = uploader.querySelectorAll('img')[0];
  const fileInput = uploader.querySelectorAll('[type="file"]')[0];
  const shouldRemoveImageButton = uploader.querySelectorAll('[type="hidden"]')[0];
  const removeButton = uploader.querySelectorAll('button')[0];

  fileInput.addEventListener('change', () => {
    const reader = new FileReader();

    reader.onload = (e) => {
      img.src = e.target.result;
    };
    reader.readAsDataURL(fileInput.files[0]);

    uploader.classList.remove('without-image');
    uploader.classList.add('with-image');
    shouldRemoveImageButton.value = 'false';
  });

  removeButton.addEventListener('click', () => {
    uploader.classList.remove('with-image');
    uploader.classList.add('without-image');
    fileInput.value = '';
    shouldRemoveImageButton.value = 'true';
  });
};

export default initImageUploader;
