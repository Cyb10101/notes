#!/usr/bin/env python3
import argparse
import os
import json
import locale
from reportlab.lib.pagesizes import A4, landscape
from reportlab.lib import colors
from reportlab.platypus import SimpleDocTemplate, Table, TableStyle, Paragraph, Spacer
from reportlab.lib.styles import getSampleStyleSheet
from reportlab.lib.units import mm
from datetime import datetime
from html import escape

# Global variables
folderNoneKey = '(none)'
bitwardenFolders = {}
bitwardenFolders[folderNoneKey] = folderNoneKey

lang, encoding = locale.getlocale()
translations = {
    'de_DE': {
        "Converts a Bitwaren JSON to a PDF": "Konvertiert eine Bitwaren JSON in eine PDF",
        "Detect system language": "Systemsprache erkennen",
        "Language %s detected": "Sprache %s erkannt",
        "Error": "Fehler",
        "File '%s' not exists!": "Die Datei '%s' existiert nicht!",
        "Text too large to display": "Text ist zu groß zum anzeigen",
        "PDF created": "PDF erstellt",
        "Password list": "Password Liste",
        "Title": "Titel",
        "Username": "Benutzer",
        "Password": "Passwort",
        "Websites": "Webseiten",
        "Notes": "Notizen",
        "Uncategorized": "Unkategorisiert",
    }
}

def translate(key, *args):
    if lang in translations and key in translations[lang]:
        return str.format(translations[lang][key] % args)
    return str.format(key % args)

def create_pdf(data, outputFile):
    pageMargin = 5*mm
    doc = SimpleDocTemplate(
        outputFile,
        pagesize=landscape(A4), rightMargin=pageMargin, leftMargin=pageMargin, topMargin=pageMargin, bottomMargin=pageMargin,
        title=translate('Password list'),
        #author="Unkown",
        subject=translate('Password list'),
        keywords="passwords, security, list"
    )

    # Stylesheets
    styles = getSampleStyleSheet()
    styleTitle = styles['Title']
    styleNormal = styles['Normal']

    # Page elements
    elements = []

    # Title and metadata
    elements.append(Paragraph(translate('Password list') + f" ({datetime.now().strftime('%d.%m.%Y')})", styleTitle))
    elements.append(Spacer(1, 2*mm))

    for folderName, folderData in data.items():
        if isinstance(folderData, list):
            if folderName == folderNoneKey:
                folderName = f"({translate('Uncategorized')})"
            elements.append(Paragraph(folderName, styles['Heading2']))

            # Prepare table data
            table_data = [
                [translate('Title'), translate('Username'), translate('Password'), translate('Websites'), translate('Notes')]
            ]
            for entry in folderData:
                table_data.append([
                    Paragraph(escape(entry.get('title', '')), styleNormal),
                    Paragraph(escape(entry.get('username', '')), styleNormal),
                    Paragraph(escape(entry.get('password', '')), styleNormal),
                    Paragraph(escape(entry.get('websites', '')).replace('\n', '<br />'), styleNormal),
                    Paragraph(escape(entry.get('notes', '')).replace('\n', '<br />'), styleNormal)
                ])

            # Add table
            pageWidth, pageHeight = landscape(A4)
            tableSize = pageWidth - (2 * pageMargin); # width - margin
            table = Table(
                table_data,
                colWidths=[tableSize * 0.2, tableSize * 0.2, tableSize * 0.2, tableSize * 0.2, tableSize * 0.2],
                repeatRows=1
            )
            table.setStyle(TableStyle([
                ('BACKGROUND', (0, 0), (-1, 0), colors.green),
                ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
                ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
                ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
                #('BOTTOMPADDING', (0, 0), (-1, 0), 8),
                ('BACKGROUND', (0, 1), (-1, -1), colors.white),
                ('GRID', (0, 0), (-1, -1), 1, colors.black),
                ('FONTNAME', (0, 1), (-1, -1), 'Helvetica'),
                #('FONTSIZE', (0, 0), (-1, -1), 12),
                ('VALIGN', (0, 0), (-1, -1), 'TOP'),
            ]))
            elements.append(table)

    doc.build(elements)

def main():
    parser = argparse.ArgumentParser(description=translate('Converts a Bitwaren JSON to a PDF'))
    parser.add_argument('inputFile', help="bitwarden.json")
    parser.add_argument('outputFile', help="print.pdf")
    parser.add_argument('--detectLang', action="store_true", help=translate('Detect system language'))
    args = parser.parse_args()

    if args.detectLang:
        print(translate('Language %s detected', lang))

    if not os.path.isfile(args.inputFile):
        print(translate('Error') + ': ' + translate("File '%s' not exists!", args.inputFile))
        exit(1)

    passwords = {}
    with open(args.inputFile, 'r') as file:
        bitwardenData = json.load(file)

        if 'folders' in bitwardenData:
            for folder in bitwardenData['folders']:
                bitwardenFolders[folder['id']] = folder['name']

        for item in bitwardenData['items']:
            username = ''
            password = ''
            websites = []

            if 'login' in item:
                if 'username' in item['login'] and item['login']['username']:
                    username = item['login']['username']
                if 'password' in item['login'] and item['login']['password']:
                    password = item['login']['password']

                if 'uris' in item['login']:
                    for entryUri in item['login']['uris']:
                        if 'uri' in entryUri:
                            websites.append(entryUri['uri'])

            notes = ''
            if item['notes']:
                notes = item['notes']
                if len(item['notes'].split('\n')) > 30 or len(item['notes']) > 1500:
                    notes = f"({translate('Error')}: {translate('Text too large to display')})"

            folder = folderNoneKey
            if 'folderId' in item:
                if item['folderId'] in bitwardenFolders:
                    folder = bitwardenFolders[item['folderId']];

            if folder not in passwords:
                passwords[folder] = []

            passwords[folder].append({
                'title': item['name'],
                'username': username,
                'password': password,
                'websites': "\n".join(websites) or '',
                'notes': notes or ''
            })

    passwords = {key: passwords[key] for key in sorted(passwords)}
    create_pdf(passwords, args.outputFile)

if __name__ == "__main__":
    main()
