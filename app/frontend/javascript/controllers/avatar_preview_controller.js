import { Controller } from "@hotwired/stimulus"
import { DirectUpload } from "@rails/activestorage"

export default class extends Controller {
  static targets = ["filename", "preview", "container"]

  connect() {
    if (!this.hasPreviewTarget && this.hasContainerTarget) {
      this.previewElement = this.containerTarget.querySelector('img');
      this.placeholderElement = this.containerTarget.querySelector('span');
    } else if (this.hasPreviewTarget) {
      this.previewElement = this.previewTarget;
    }
  }

  updatePreview(event) {
    const input = event.target;

    if (input.files && input.files[0]) {
      const file = input.files[0];

      this.filenameTarget.textContent = file.name;

      const reader = new FileReader();

      reader.onload = (e) => {
        if (this.hasContainerTarget) {
          if (this.previewElement) {
            this.previewElement.src = e.target.result;
            this.previewElement.classList.remove('hidden');

            if (this.placeholderElement) {
              this.placeholderElement.classList.add('hidden');
            }
          } else {
            this.containerTarget.innerHTML = '';

            const img = document.createElement('img');
            img.src = e.target.result;
            img.alt = "Avatar preview";
            img.className = "w-full h-full object-cover";
            img.dataset.avatarPreviewTarget = "preview";

            this.containerTarget.appendChild(img);
            this.previewElement = img;
          }
        }
      };

      reader.readAsDataURL(file);

      if (input.dataset.directUploadUrl) {
        this.directUpload(file, input.dataset.directUploadUrl);
      }
    }
  }

  directUpload(file, url) {
    const upload = new DirectUpload(file, url);

    upload.create((error, blob) => {
      if (error) {
        console.error('Error uploading file', error);
      } else {
        const hiddenField = document.createElement('input');
        hiddenField.type = 'hidden';
        hiddenField.name = 'user[avatar]';
        hiddenField.value = blob.signed_id;
        this.element.appendChild(hiddenField);
      }
    });
  }
}
