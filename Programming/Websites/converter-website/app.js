class ReadUpload {
    constructor() {
        let instance = this;
        this.language = document.querySelector('input[type=radio][name="language"]:checked').value;
        this.output = document.querySelector('#output');
        this.dropzoneUtility = new DropzoneUtility();
        this.bitwardenToPdf = new BitwardenToPdf();
        this.bitwardenToPdf.changeLanguage(this.language);

        this.bindLanguage();

        this.output.addEventListener('dblclick', () => {
            window.getSelection().selectAllChildren(output);
        });

        this.dropzoneUtility.each(dropzone => {
            dropzone.style.display = 'block';
            dropzone.addEventListener('filedrop', (event) => {
                const action = event.action;
                const files = event.files;

                if (files.length > 0) {
                    let allowedImagesMimeTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'];
                    files.forEach(file => {
                        if (file.type && file.type === 'application/json') {
                            instance.readJson(file);
                        } else if (file.type && allowedImagesMimeTypes.includes(file.type)) {
                            instance.readImage(file);
                        } else {
                            instance.addOutputMessage(file.name, 'Unknown type "' + file.type + '"!');
                        }
                    })
                }

            });
        });
    }

    bindLanguage() {
        let instance = this;
        let radios = document.querySelectorAll('input[type=radio][name="language"]');
        if (radios.length > 0) {
            radios.forEach((radio) => {
                radio.addEventListener('change', (event) => {
                    instance.language = event.target.value;
                    instance.bitwardenToPdf.changeLanguage(instance.language);
                });
            });
        }
    }

    readJson(file) {
        let instance = this;
        this.dropzoneUtility.readJson(file, (jsonFile, jsonData) => {
            if (jsonData.hasOwnProperty('encrypted') && jsonData.hasOwnProperty('folders') && jsonData.hasOwnProperty('items')) {
                if (jsonData.encrypted) {
                    instance.addOutputMessage(jsonFile.name, 'File is encrypted!');
                } else {
                    instance.addOutputMessage(jsonFile.name, 'File processed.');
                    if (document.getElementById('bitwarden-print').checked) {
                        instance.bitwardenToPdf.printContent(instance.bitwardenToPdf.convertJsonToHTML(jsonData));
                    } else {
                        instance.addOutput(instance.bitwardenToPdf.convertJsonToHTML(jsonData));
                    }
                }
            } else {
                instance.addOutputMessage(jsonFile.name, JSON.stringify(jsonData));
            }
        });
    }

    readImage(file) {
        let instance = this;
        this.dropzoneUtility.readImage(file, (imageFile, image) => {
            instance.insertOutput(image);
        });
    }

    getOutput() {
        return this.output.innerHTML;
    }

    setOutput(content) {
        this.output.innerHTML = content;
    }

    addOutput(content) {
        this.output.innerHTML = content + this.getOutput();
    }

    addOutputMessage(fileName, message) {
        this.output.innerHTML = (fileName ? '<h6>' + fileName + '</h6> ' : '') + message + '<br><br>' + this.getOutput();
    }
    
    insertOutput(content) {
        this.output.insertBefore(content, this.output.childNodes[0]);
    }

    appendOutput(content) {
        this.output.append(content);
    }
}

document.addEventListener('DOMContentLoaded', () => {
    const readUpload = new ReadUpload();
}, false);
