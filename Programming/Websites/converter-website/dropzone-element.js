/*
accept file type not parsed: .json
for one file remove 'multiple'
file-drop & input must have the same 'accept' & 'multiple'

<file-drop accept="application/json, image/jpeg, image/jpg, image/png, image/gif" multiple style="display: none;">
    <h2>Dropzone</h2>
    <input type="file" class="form-control" accept="application/json, image/jpeg, image/jpg, image/png, image/gif" multiple>
</file-drop>
*/

class DropzoneUtility {
    each(callback) {
        const dropzones = document.querySelectorAll('file-drop');
        if (dropzones.length > 0) {
            dropzones.forEach(dropzone => {
                callback(dropzone);
            });
        }
    }

    filterFiles(dataTransferItems, htmlAccept, multiple) {
        const dataTransferItemsList = Array.from(dataTransferItems);

        // Only files
        let dataTransferItemsFiltered = dataTransferItemsList.filter(item => item.kind === 'file');

        // Filter by htmlAccept
        if (htmlAccept !== '') {
            // ignore '.json', convert 'application/json' to '[application, json]'
            const acceptMimeTypes = htmlAccept.toLowerCase().split(',')
                .map(
                    item => item.split('/').map(item => item.trim())
                )
                .filter(item => 2 === item.length);

            dataTransferItemsFiltered = dataTransferItemsFiltered.filter(item => {
                // convert 'application/json' to '[application, json]'
                const [mimeTypeFile, mimeSubTypeFile] = item.type.toLowerCase().split('/').map(item => item.trim());
                for (const [mimeType, mimeSubType] of acceptMimeTypes) {
                    if (mimeTypeFile === mimeType && (mimeSubType === '*' || mimeSubType === mimeSubTypeFile)) {
                        return true;
                    }
                }

                return false
            });
        }

        if (dataTransferItemsFiltered.length === 0) {
            return [];
        }
        return multiple ? dataTransferItemsFiltered : [dataTransferItemsFiltered[0]];
    }

    files(eventDataTransfer, accept, multiple) {
        const list = [];
        return this.filterFiles(eventDataTransfer.items, accept, multiple).forEach(dataTransferItem => {
            const acceptFile = dataTransferItem.getAsFile();
            acceptFile !== null && list.push(acceptFile);
        }), list;
    }

    readJson(file, callback) {
        if (!file.type || file.type !== 'application/json') {
            console.error('File is not an json!');
            return;
        }

        const reader = new FileReader();
        reader.addEventListener('load', (event) => {
            let content = event.target.result;
            content = JSON.parse(content);
            callback(file, content);
        });
        reader.readAsText(file);
    }

    readImage(file, callback) {
        let allowedMimeTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'];
        if (!file.type || !allowedMimeTypes.includes(file.type)) {
            console.error('File is not an image!');
            return;
        }

        const reader = new FileReader();
        reader.addEventListener('load', (event) => {
            let content = event.target.result;
            let image = document.createElement('img');
            image.src = event.target.result;
            // content = content.substring(content.indexOf('base64,') + 7);
            // content = JSON.parse(atob(content));
            callback(file, image);
        });
        reader.readAsDataURL(file);
    }
}

class DropzoneEvent extends Event {
    constructor(type, eventInit) {
        super(type, eventInit);
        if (!this instanceof DropzoneEvent) {
            Object.setPrototypeOf(this, DropzoneEvent.prototype);
        }
        this._files = eventInit.files;
        this._action = eventInit.action;
    }

    get action() {
        return this._action;
    }

    get files() {
        return this._files;
    }
}

class DropzoneElement extends HTMLElement {
    constructor() {
        super();
        this.dropzoneUtility = new DropzoneUtility();
        this._dragEnterCount = 0;
        this._onDragEnter = this._onDragEnter.bind(this);
        this._onDragLeave = this._onDragLeave.bind(this);
        this._onDrop = this._onDrop.bind(this);
        this._onPaste = this._onPaste.bind(this);
        this.addEventListener('dragover', event => event.preventDefault());
        this.addEventListener('drop', this._onDrop);
        this.addEventListener('dragenter', this._onDragEnter);
        this.addEventListener('dragend', () => this._reset());
        this.addEventListener('dragleave', this._onDragLeave);
        this.addEventListener('paste', this._onPaste);
        this.addEventListener('change', this._onChange);
    }

    get accept() {
        return this.getAttribute('accept') || '';
    }

    set accept(fileTypes) {
        // this.setAttribute('accept', fileTypes);
        if (fileTypes) {
            this.setAttribute('accept', fileTypes);
        } else {
            this.removeAttribute('accept');
        }
    }

    get multiple() {
        let multiple = this.getAttribute('multiple');
        multiple = (multiple !== null && (multiple != false || multiple === ''));
        return multiple;
    }

    set multiple(value) {
        if (value !== false) {
            this.setAttribute('multiple', value);
        } else {
            this.removeAttribute('multiple');
        }
    }

    _onDragEnter(event) {
        // console.log('_onDragEnter', event);
        this._dragEnterCount += 1;
        if (this._dragEnterCount > 1) {
            return;
        }
        
        if (event.dataTransfer === null || event.dataTransfer.items.length === 0) {
            this.classList.add('drop-invalid');
            return;
        }

        if (!this.multiple && event.dataTransfer.items.length > 1) {
            this.classList.add('drop-invalid');
            return;
        }

        const dataTransferItems = this.dropzoneUtility.filterFiles(event.dataTransfer.items, this.accept, this.multiple);
        this.classList.add(dataTransferItems.length === 0 ? 'drop-invalid' : 'drop-valid');
    }

    _onDragLeave() {
        this._dragEnterCount -= 1;
        if (this._dragEnterCount === 0) {
            this._reset();
        }
    }

    _onDrop(event) {
        event.preventDefault();
        if (event.dataTransfer === null) {
            return;
        }
        this._reset();

        const files = this.dropzoneUtility.files(event.dataTransfer, this.accept, this.multiple);
        if (files.length > 0) {
            this.dispatchEvent(new DropzoneEvent('filedrop', {
                action: 'drop',
                files: files
            }));
        } else {
            this._resetError();
        }
    }

    _onPaste(event) {
        if (!event.clipboardData) {
            return;
        }

        const files = this.dropzoneUtility.files(event.clipboardData, this.accept, this.multiple);
        if (files.length > 0) {
            this.dispatchEvent(new DropzoneEvent('filedrop', {
                action: 'paste',
                files: files
            }));
        } else {
            this._resetError();
        }
    }

    _onChange(event)  {
        if (!(event.target && event.target.files && event.target.files.length > 0)) {
            return;
        }

        const dataTransfer = new DataTransfer();
        for (let i = 0; i < event.target.files.length; i++) {
            dataTransfer.items.add(event.target.files[i]);
        }

        const files = this.dropzoneUtility.files(dataTransfer, this.accept, this.multiple);
        if (files.length > 0) {
            this.dispatchEvent(new DropzoneEvent('filedrop', {
                action: 'paste',
                files: files
            }));
        } else {
            this._resetError();
        }
    }

    _reset() {
        let instance = this;
        this._dragEnterCount = 0;
        this.classList.remove('drop-valid');
        this.classList.remove('drop-invalid');
    }

    _resetError() {
        let instance = this;
        this.classList.add('drop-invalid');
        setTimeout(() => {
            instance._reset();
        }, 1000);
    }
}

customElements.define('file-drop', DropzoneElement);
