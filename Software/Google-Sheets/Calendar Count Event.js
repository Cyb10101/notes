// Tools > Script editor > File: Code.gs
// Resources > Advanced Google Services > Calendar

function onOpen() {
  var ui = SpreadsheetApp.getUi();
  // Or DocumentApp or FormApp.
  ui.createMenu('Own scripts')
    .addItem('Search Calendar Events', 'searchCalendarEvents')
    .addSeparator()
    .addSubMenu(ui.createMenu('Development')
      .addItem('First item', 'devMenuItem1')
      .addItem('Second item', 'devMenuItem2')
    )
    .addToUi();
}

function devMenuItem1() {
  var ui = SpreadsheetApp.getUi();
  var response = ui.prompt('Getting to know you', 'May I know your name?', ui.ButtonSet.YES_NO);

  if (response.getSelectedButton() == ui.Button.YES) {
    Logger.log('The user\'s name is %s.', response.getResponseText());
  } else if (response.getSelectedButton() == ui.Button.NO) {
    Logger.log('The user didn\'t want to provide a name.');
  } else {
    Logger.log('The user clicked the close button in the dialog\'s title bar.');
  }
}

function devMenuItem2() {
  SpreadsheetApp.getUi().alert('You clicked the second menu item!');
}

function searchCalendarEvents() {
  var sheet = SpreadsheetApp.getActiveSheet();
  addDefaultFields(sheet);

  var calendarName = sheet.getRange('B1').getValue();
  var myCalendarId = getCalendarKey(calendarName);

  var searchEvents = searchColumn(1, 'Event');
  if (searchEvents) {
    var columnValues = sheet.getRange(searchEvents + 1, 1, sheet.getLastRow()).getValues();
    if (columnValues) {
      for (var i = 0; i < columnValues.length; i++) {
        var eventName = columnValues[i][0];
        if (eventName !== '') {
          var fromDate = sheet.getRange(searchEvents + 1 + i, 2).setHorizontalAlignment('center').getValue();
          if (!isValidDate(fromDate)) {
            fromDate = new Date();
            sheet.getRange(searchEvents + 1 + i, 2).setValue(fromDate);
          }

          var eventsInTime = getCalendarEventsInTime(myCalendarId, eventName, fromDate, new Date());
          sheet.getRange(searchEvents + 1 + i, 3).setValue(countEvents(eventsInTime)).setHorizontalAlignment('center');

          sheet.getRange(searchEvents + 1 + i, 4).setHorizontalAlignment('center');

          var updated = Utilities.formatDate(new Date(), "GMT+1", "dd.MM.yyyy");
          sheet.getRange(searchEvents + 1 + i, 5).setValue(updated).setHorizontalAlignment('center');
        }
      }
    } else {
      SpreadsheetApp.getUi().alert('No columns found!');
    }
  } else {
    SpreadsheetApp.getUi().alert('Event marker not found!');
  }
}

function addDefaultFields(sheet) {
  if (sheet.getRange('A1').getValue() === '') {
    sheet.getRange('A1').setValue('Calendar name:').setFontWeight('bold').setHorizontalAlignment('left');
  }
  if (sheet.getRange('B1').getValue() === '') {
    var ui = SpreadsheetApp.getUi();
    var response = ui.prompt('Calendar name', 'What is the name of the calendar?', ui.ButtonSet.OK);
    var calendarName = (response.getResponseText() !== '' ? response.getResponseText() : 'General');
    sheet.getRange('B1').setValue(calendarName).setHorizontalAlignment('left');
  }

  // Table header
  if (sheet.getRange('A3').getValue() === '') {
    sheet.getRange('A3').setValue('Event').setFontWeight('bold').setHorizontalAlignment('center');
  }
  if (sheet.getRange('B3').getValue() === '') {
    sheet.getRange('B3').setValue('Start date').setFontWeight('bold').setHorizontalAlignment('center');
  }
  if (sheet.getRange('C3').getValue() === '') {
    sheet.getRange('C3').setValue('Current count').setFontWeight('bold').setHorizontalAlignment('center');
  }
  if (sheet.getRange('D3').getValue() === '') {
    sheet.getRange('D3').setValue('Maximum count').setFontWeight('bold').setHorizontalAlignment('center');
  }
  if (sheet.getRange('E3').getValue() === '') {
    sheet.getRange('E3').setValue('Updated').setFontWeight('bold').setHorizontalAlignment('center');
  }

  // Table example data
  if (sheet.getRange('A4').getValue() === '') {
    sheet.getRange('A4').setValue('Event name').setHorizontalAlignment('left');
    sheet.getRange('B4').setValue('01.01.2020').setHorizontalAlignment('center');
    sheet.getRange('C4').setValue(0).setHorizontalAlignment('center');
    sheet.getRange('D4').setValue(10).setHorizontalAlignment('center');
    sheet.getRange('E4').setValue(Utilities.formatDate(new Date(), "GMT+1", "dd.MM.yyyy")).setHorizontalAlignment('center');
  }
}

function countEvents(events) {
  if (events.items && events.items.length > 0) {
    return events.items.length;
  }
  return 0;
}

function getCalendarEventsInTime(calendarId, eventName, fromDate, toDate) {
  var events = Calendar.Events.list(calendarId, {
    timeMin: fromDate.toISOString(),
    timeMax: toDate.toISOString(),
    q: eventName,
    singleEvents: true,
    orderBy: 'startTime',
    maxResults: 100
  });
  return events;
}

function getCalendarKey(calendarKey) {
  var calendars, pageToken;
  var calendarId = '';
  do {
    calendars = Calendar.CalendarList.list({
      maxResults: 100,
      pageToken: pageToken
    });

    if (calendars.items && calendars.items.length > 0) {
      for (var i = 0; i < calendars.items.length; i++) {
        var calendar = calendars.items[i];
        if (calendar.summary === calendarKey){
          calendarId = calendar.id;
          return calendarId;
        }
      }
    } else {
      Logger.log('No calendars found.');
    }
    pageToken = calendars.nextPageToken;
  } while (pageToken);
  return calendarId;
}

function searchColumn(column, searchString) {
  var sheet = SpreadsheetApp.getActiveSheet();
  var columnValues = sheet.getRange(1, column, sheet.getLastRow()).getValues();
  var searchResult = columnValues.findIndex(searchString);

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
