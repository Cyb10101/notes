/**
 * <html lang="de"> = document.documentElement.lang
 * const bitwardenToPdf = new BitwardenToPdf();
 * bitwardenToPdf.changeLanguage(document.documentElement.lang);
 */
class BitwardenToPdf {
    constructor() {
        this.language = 'en';
        /*this.form = document.getElementById('bitwardenToPdf');
        if (!this.form) {
            return;
        }*/

        this.translation = {
            en: {
                'Passwords': 'Passwords',
                'Title': 'Title',
                'Username': 'Username',
                'Password': 'Password',
                'URL': 'URL',
                'Fields': 'Fields',
                'Notes': 'Notes',
                'TOTP': 'TOTP',
            },
            de: {
                'Passwords': 'Passwörter',
                'Title': 'Titel',
                'Username': 'Benutzer',
                'Password': 'Passwort',
                'URL': 'URL',
                'Fields': 'Felder',
                'Notes': 'Notizen',
                'TOTP': 'TOTP',
            }
        };

        this.columns = [
            'Title',
            'Username',
            'Password',
            'URL',
        ];
    }

    initialize() {
        let instance = this;
        document.getElementById('convert').addEventListener('click', function() {
            instance.convert();
        });
    }

    changeLanguage(language) {
        this.language = this.translation.hasOwnProperty(language) ? language : 'en';
    }

    translate(key) {
        if (this.translation.hasOwnProperty(this.language) && this.translation[this.language].hasOwnProperty(key)) {
            return this.translation[this.language][key];
        }
        return key
    }

    convert() {
        this.setAlert();
        try {
            let code = this.form.bitwardenToPdf_json.value;
            code = JSON.parse(code);
            this.printContent(this.convertJsonToHTML(code));
        } catch (exception) {
            this.setAlert(exception);
        }
    }

    setAlert(message) {
        let alert = this.form.querySelector('.alert');
        let show = (message && message !== '');
        alert.innerHTML = show ? '<b>Error</b><br>' + message : '';
        alert.style.display = show ? 'block' : 'none';
    }

    convertJsonToHTML(passwords) {
        let content = '';

        let count = 0;
        passwords.items.forEach(item => {
            let trClass = (count % 2 ? 'odd' : 'even')
            content += '<tr class="' + trClass + '"><td>' + item.name + '</td>';
            content += '<td>' + (item.login && item.login.username ? item.login.username : '') + '</td>';
            content += '<td>' + (item.login && item.login.password ? item.login.password : '') + '</td>';

            content += '<td>';
            if (item.login && item.login.uris) {
                item.login.uris.forEach(uri => {
                    content += (uri.uri ? uri.uri : '') + '<br>';
                });
            }
            content += '</td></tr>';

            if (item.login && item.login.totp) {
                content += '<tr class="' + trClass + '"><td style="text-align: right;">' + this.translate('TOTP') + ':</td><td colspan="3">' + item.login.totp + '</td></tr>';
            }

            if (item.fields) {
                let fieldText = '';
                item.fields.forEach(field => {
                    fieldText += '<br>' + field.name + ': ' + field.value;
                });
                content += '<tr class="' + trClass + '"><td style="text-align: right;">' + this.translate('Fields') + ':</td><td colspan="3">' + fieldText + '</td></tr>';
            }


            if (item.notes) {
                let notes = item.notes.replace(/(?:\r\n|\r|\n)/g, '<br>');
                notes = notes.replace(/^(\s|<br>)*(.*?)(\s|<br>)*$/, '$2'); // Trim new line
                content += '<tr class="' + trClass + '"><td style="text-align: right;">' + this.translate('Notes') + ':</td><td colspan="3">' + notes + '</td></tr>';
            }

            count++;
        });
        if (content !== '') {
            content = '<tbody>' + content + '</tbody>';
        }

        return '<table id="table" class="table table-striped">'
            + '<thead><tr><th>' + this.columns.map(column => this.translate(column)).join('</th><th>') + '</th></tr></thead>'
            + content + '</table>';
    }

    getStyleElement() {
        let css = 'body {margin: 0px;font-family: "Segoe UI",Roboto,"Helvetica Neue",Arial,"Noto Sans",sans-serif; font-size: 1rem; font-weight: 400; line-height: 1.5; color: #212529; text-align: left;}'
            + 'a {color: #007bff; text-decoration: none; background-color: transparent;}'
            + 'a:hover {color: #0056b3; text-decoration: underline;}'

            + 'table {width: 100%; margin-bottom: 1rem; color: #212529; border-collapse: collapse;}'
            + 'table thead th {text-align: left; vertical-align: bottom; border-bottom: 2px solid #dee2e6;}'
            + 'table td, table th {padding: .25rem; vertical-align: top; border-top: 1px solid #dee2e6;}'

            + 'table tr.odd + tr.odd td,'
            + 'table tr.even + tr.even td {border-top: none;}'

            + 'table tr {height: 100%;}'
            + 'table td {padding: .25rem; height: calc(100% - .75rem);}'

            + 'table tbody tr.even {background-color: rgba(0,0,0,.05);}'
            + '@media print {'
            + 'tr td, tr {page-break-inside: avoid;}'
            + '@page {size: landscape;}'
            + '}';

        let style = document.createElement('style');
        style.appendChild(document.createTextNode(css));
        return style;
    }

    printContent(content) {
        let windowPrint = window.open('', 'PRINT', 'width=1000,height=600');
        if (windowPrint) {
            windowPrint.document.write('<html><head><title>' + this.translate('Passwords') + '</title>');
            windowPrint.document.write(this.getStyleElement().outerHTML);
            windowPrint.document.write('</head><body><div>');
            windowPrint.document.write(content);
            windowPrint.document.write('</div></body></html>');
    
            windowPrint.document.close(); // necessary for IE >= 10
            windowPrint.focus(); // necessary for IE >= 10
    
            windowPrint.print();
            windowPrint.close();
            return true;
        }
        return false;
    }
}
