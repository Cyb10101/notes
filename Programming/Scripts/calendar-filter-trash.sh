#!/usr/bin/env python3

# python3 -m venv venv && source venv/bin/activate && python3 -m pip install icalendar
# ~/Sync/notes/Programming/Scripts/calendar-filter-trash.sh trash.ics trash_clean.ics

from icalendar import Calendar, Event, Alarm
from datetime import datetime, date, time, timedelta, timezone
from zoneinfo import ZoneInfo
from pathlib import Path
import sys
import os

BERLIN = ZoneInfo("Europe/Berlin")

def read_cal(p):
    return Calendar.from_ical(Path(p).read_bytes())

def write_cal(cal, p):
    Path(p).write_bytes(cal.to_ical())

def get_summary(comp):
    return str(comp.get("summary", "")).strip()

def remove_valarms(ev):
    ev.subcomponents = [c for c in ev.subcomponents if getattr(c, "name", "") != "VALARM"]

def _event_local_start(ev, tz=BERLIN):
    dtstart = ev.decoded("dtstart")
    if isinstance(dtstart, date) and not isinstance(dtstart, datetime):
        # all-day event: treat start at 00:00 local
        return datetime.combine(dtstart, time.min).replace(tzinfo=tz)
    if isinstance(dtstart, datetime):
        # normalize to given tz (keep civil date of event in that tz)
        return dtstart.astimezone(tz) if dtstart.tzinfo else dtstart.replace(tzinfo=tz)
    return None

def ensure_alarm_at_local_prevdays(ev, days_before=1, hour=18, minute=0, tz=BERLIN, desc="Reminder"):
    start_local = _event_local_start(ev, tz)
    if not start_local:
        return

    trigger_local = datetime.combine(start_local.date() - timedelta(days=days_before), time(hour, minute), tz)
    remove_valarms(ev)
    alarm = Alarm()
    alarm.add("action", "DISPLAY")
    alarm.add("description", desc)
    # @bug Not imported: alarm.add("trigger", trigger_local.astimezone(timezone.utc)) # Absolute time trigger
    # Relative trigger is much more likely to survive Google Calendar import
    alarm.add("trigger", trigger_local - start_local) # Relative time trigger
    ev.add_component(alarm)

def process(in_path, out_path):
    cal = read_cal(in_path)
    new_subs = []
    removed = 0
    updated = 0

    for comp in cal.subcomponents:
        if getattr(comp, "name", "") != "VEVENT":
            new_subs.append(comp)
            continue

        summary = get_summary(comp)

        if summary == "Restmüll 2-wöchentlich":
            removed += 1
            continue

        if summary == "Restmüll 4-wöchentlich":
            ensure_alarm_at_local_prevdays(comp, days_before=1, hour=17, minute=30, tz=BERLIN, desc=f"Restmüll morgen")
            updated += 1
        elif summary == "Gelbe/r Sack/Tonne":
            ensure_alarm_at_local_prevdays(comp, days_before=1, hour=17, minute=30, tz=BERLIN, desc=f"Gelbe Tonne morgen")
            updated += 1
        elif summary in {"Papiertonne", "Biotonne"}:
            ensure_alarm_at_local_prevdays(comp, days_before=1, hour=17, minute=30, tz=BERLIN, desc=f"{summary} morgen")
            updated += 1
        else:
            ensure_alarm_at_local_prevdays(comp, days_before=2, hour=17, minute=30, tz=BERLIN, desc=f"{summary} bald")
            updated += 1

        new_subs.append(comp)

    cal.subcomponents = new_subs
    write_cal(cal, out_path)
    print(f"Removed: {removed} | Alarm-updated: {updated}")

def main():
    if len(sys.argv) != 3:
        scriptname = os.path.basename(sys.argv[0])
        print("Filters unwanted events and add alarms.")
        print(f"Usage: {scriptname} input.ics output.ics")
        sys.exit(1)
    process(sys.argv[1], sys.argv[2])

if __name__ == "__main__":
    main()
