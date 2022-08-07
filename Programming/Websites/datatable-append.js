/**
 * Append Datatables in Website
 * https://datatables.net/
 */

// Append dependencies
function addCssFile(file) {
    let link = document.createElement('link');
    link.href = file;
    link.type = 'text/css';
    link.rel = 'stylesheet';
    document.getElementsByTagName('head')[0].appendChild(link);
}

function addJsFile(file, callback) {
    var script = document.createElement('script');
    script.src = file;
    script.type = 'text/javascript';
    if (callback) {
        script.onreadystatechange = callback;
        script.onload = callback;
    }
    document.getElementsByTagName('head')[0].appendChild(script);
}

function tableFixFirstColumn(table) {
    let thead = table.querySelector('thead');
    if (!thead) {
        thead = document.createElement('thead');
        table.appendChild(thead);
    }
    if (thead.children.length < 1) {
        let tbody = table.querySelector('tbody');
        if (tbody) {
            thead.appendChild(tbody.querySelector('tr'));
        } else {
            thead.appendChild(table.querySelector('tr'));
        }
    }
}

addCssFile('https://cdn.datatables.net/1.12.1/css/jquery.dataTables.min.css');
addJsFile('https://code.jquery.com/jquery-3.6.0.min.js', () => {
    console.log('jQuery added');
    addJsFile('https://cdn.datatables.net/1.12.1/js/jquery.dataTables.min.js', () => {
        console.log('Datatables added');
    });
});

// Run code
let tableSource = document.querySelector('table');
tableFixFirstColumn(tableSource);
let table = $(tableSource).DataTable();
