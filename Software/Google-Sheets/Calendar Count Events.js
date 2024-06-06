// Extensions > Apps Script > File: Code.gs
// Resources/Services > Advanced Google Services > Calendar

function onOpen() {
  const ui = SpreadsheetApp.getUi();
  // Or DocumentApp or FormApp.
  ui.createMenu('Own scripts')
    .addItem('Search Calendar Events', 'searchCalendarEvents')
    .addSeparator()
    .addSubMenu(ui.createMenu('Development')
      .addItem('Yes/No Test', 'devTestYesNo')
    )
    .addToUi();
}

function devTestYesNo() {
  const ui = SpreadsheetApp.getUi();
  const response = ui.prompt('Getting to know you', 'May I know your name?', ui.ButtonSet.YES_NO);
  if (response.getSelectedButton() == ui.Button.YES) {
    Logger.log('The user\'s name is "%s."', response.getResponseText());
    ui.alert(`The user's name is "${response.getResponseText()}".`);
  } else if (response.getSelectedButton() == ui.Button.NO) {
    Logger.log('The user didn\'t want to provide a name.');
    ui.alert('The user didn\'t want to provide a name.');
  } else {
    Logger.log('The user clicked the close button in the dialog\'s title bar.');
    ui.alert('The user clicked the close button in the dialog\'s title bar.');
  }
}

function searchCalendarEvents() {
  const sheet = SpreadsheetApp.getActiveSheet();
  const ui = SpreadsheetApp.getUi();

  let rowHeader = searchColumn(1, 'Calendar name');
  if (!rowHeader) {
      const response = ui.alert('Column marker not found! Create a new example?', ui.ButtonSet.YES_NO);
      if (response == ui.Button.YES) {
        addDefaultFields(sheet);
        rowHeader = searchColumn(1, 'Calendar name');
      } else {
        return;
      }
  }

  const columnValues = sheet.getRange(rowHeader + 1, 1, sheet.getLastRow()).getValues();
  if (!columnValues) {
    SpreadsheetApp.getUi().alert('No data columns found!');
    return;
  }

  for (let i = 0; i < columnValues.length; i++) {
    const calendarName = columnValues[i][0];
    const eventName = sheet.getRange(rowHeader + 1 + i, 2).getValue();

    if (calendarName === '' && eventName === '') {
      continue;
    } else if ((calendarName === '' && eventName !== '') || (calendarName !== '' && eventName === '')) {
      SpreadsheetApp.getUi().alert(`Error: Calendar '${calendarName}' with event '${eventName}' on row ${rowHeader + 1 + i} not filled properly!`);
      continue;
    }

    const myCalendarId = getCalendarKey(calendarName);
    if (!myCalendarId) {
      SpreadsheetApp.getUi().alert(`Error: Calendar '${calendarName}' with event '${eventName}' on row ${rowHeader + 1 + i} not found!`);
      continue;
    }

    let fromDate = sheet.getRange(rowHeader + 1 + i, 3).setHorizontalAlignment('center').getValue();
    if (!isValidDate(fromDate)) {
      fromDate = new Date();
      sheet.getRange(rowHeader + 1 + i, 3).setNumberFormat('dd.mm.yyyy').setValue(fromDate);
    }

    const eventsInTime = getCalendarEventsInTime(myCalendarId, eventName, fromDate, new Date());
    sheet.getRange(rowHeader + 1 + i, 4).setNumberFormat('0').setValue(countEvents(eventsInTime)).setHorizontalAlignment('center');

    sheet.getRange(rowHeader + 1 + i, 5).setNumberFormat('0').setHorizontalAlignment('center');

    const updated = Utilities.formatDate(new Date(), 'GMT+1', 'dd.MM.yyyy');
    sheet.getRange(rowHeader + 1 + i, 6).setNumberFormat('dd.mm.yyyy').setValue(updated).setHorizontalAlignment('center');
  }
}

function addDefaultFields(sheet) {
  const ui = SpreadsheetApp.getUi();

  // Table header
  let rowNumber = 1;
  if (sheet.getRange('A' + rowNumber).getValue() === '') {
    sheet.getRange('A' + rowNumber).setValue('Calendar name').setFontWeight('bold').setHorizontalAlignment('left');
  }
  if (sheet.getRange('B' + rowNumber).getValue() === '') {
    sheet.getRange('B' + rowNumber).setValue('Event name').setFontWeight('bold').setHorizontalAlignment('left');
  }
  if (sheet.getRange('C' + rowNumber).getValue() === '') {
    sheet.getRange('C' + rowNumber).setValue('Start date').setFontWeight('bold').setHorizontalAlignment('center');
  }
  if (sheet.getRange('D' + rowNumber).getValue() === '') {
    sheet.getRange('D' + rowNumber).setValue('Current count').setFontWeight('bold').setHorizontalAlignment('center');
  }
  if (sheet.getRange('E' + rowNumber).getValue() === '') {
    sheet.getRange('E' + rowNumber).setValue('Maximum count').setFontWeight('bold').setHorizontalAlignment('center');
  }
  if (sheet.getRange('F' + rowNumber).getValue() === '') {
    sheet.getRange('F' + rowNumber).setValue('Updated').setFontWeight('bold').setHorizontalAlignment('center');
  }

  // Table data
  rowNumber = 2;
  if (sheet.getRange('A' + rowNumber).getValue() === '') {
    const response = ui.prompt('Calendar name', 'What is the name of the calendar?', ui.ButtonSet.OK);
    const calendarName = (response.getResponseText() !== '' ? response.getResponseText() : 'General');
    sheet.getRange('A' + rowNumber).setValue(calendarName).setHorizontalAlignment('left');
  }
  if (sheet.getRange('B' + rowNumber).getValue() === '') {
    const response = ui.prompt('Event name', 'What is the name of the event?', ui.ButtonSet.OK);
    const calendarName = (response.getResponseText() !== '' ? response.getResponseText() : 'Meeting');
    sheet.getRange('B' + rowNumber).setValue(calendarName).setHorizontalAlignment('left');
  }
  sheet.getRange('C' + rowNumber).setNumberFormat('dd.mm.yyyy').setValue('01.01.2020').setHorizontalAlignment('center');
  sheet.getRange('D' + rowNumber).setNumberFormat('0').setValue(0).setHorizontalAlignment('center');
  sheet.getRange('E' + rowNumber).setNumberFormat('0').setValue(10).setHorizontalAlignment('center');
  sheet.getRange('F' + rowNumber).setNumberFormat('dd.mm.yyyy').setValue(Utilities.formatDate(new Date(), "GMT+1", "dd.MM.yyyy")).setHorizontalAlignment('center');
}

function countEvents(events) {
  if (events.items && events.items.length > 0) {
    return events.items.length;
  }
  return 0;
}

function getCalendarEventsInTime(calendarId, eventName, fromDate, toDate) {
  const events = Calendar.Events.list(calendarId, {
    timeMin: fromDate.toISOString(),
    timeMax: toDate.toISOString(),
    q: eventName,
    singleEvents: true,
    orderBy: 'startTime',
    maxResults: 100
  });

  events.items = events.items.filter(function  (event) {
    return event.getSummary().match('^(\s+)?' + eventName + '(\s+)?$') !== null;
  });

  return events;
}

function getCalendarKey(calendarName) {
  let calendars, pageToken;
  do {
    calendars = Calendar.CalendarList.list({
      maxResults: 100,
      pageToken: pageToken
    });

    if (calendars.items && calendars.items.length > 0) {
      for (let i = 0; i < calendars.items.length; i++) {
        const itemCalendar = calendars.items[i];
        if (itemCalendar.summary === calendarName){
          return itemCalendar.id;
        }
      }
    } else {
      Logger.log('No calendars found.');
    }
    pageToken = calendars.nextPageToken;
  } while (pageToken);
  return '';
}

function searchColumn(column, searchString) {
  const sheet = SpreadsheetApp.getActiveSheet();
  const columnValues = sheet.getRange(1, column, sheet.getLastRow()).getValues();
  let searchResult = columnValues.findIndex(searchString);

  if (searchResult !== -1) {
    searchResult += 1; // Because findIndex() array start with zero
    return searchResult;
  }
  return false;
}

Array.prototype.findIndex = function(search) {
  if (search === '') {
    return false;
  }
  for (var i = 0; i < this.length; i++) {
    if (this[i] == search) {
      return i;
    }
  }
  return -1;
}

function isValidDate(date) {
  return (Object.prototype.toString.call(date) === "[object Date]");
}
