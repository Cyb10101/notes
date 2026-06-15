#!/usr/bin/env python3
import argparse
import csv
import json
import os
import re
import sys
from datetime import date, datetime, time, timezone
from pathlib import Path

try:
    from icalendar import Calendar
except ImportError:
    Calendar = None

try:
    import recurring_ical_events
except ImportError:
    recurring_ical_events = None

try:
    import caldav
except ImportError:
    caldav = None


def parse_date(value: str) -> datetime:
    return datetime.combine(date.fromisoformat(value), time.min).replace(tzinfo=timezone.utc)


def today_utc() -> datetime:
    return datetime.combine(date.today(), time.max).replace(tzinfo=timezone.utc)


def normalize_dt(value) -> datetime:
    if isinstance(value, datetime):
        dt = value
    elif isinstance(value, date):
        dt = datetime.combine(value, time.min)
    else:
        raise ValueError(f"Unsupported date value: {value!r}")

    if dt.tzinfo is None:
        return dt.replace(tzinfo=timezone.utc)

    return dt.astimezone(timezone.utc)


def exact_title_match(title: str, expected: str) -> bool:
    return re.fullmatch(rf"\s*{re.escape(expected)}\s*", title or "") is not None


def load_config(path: Path) -> dict:
    with path.open("r", encoding="utf-8") as f:
        config = json.load(f)

    config.setdefault("caldav", {})
    config.setdefault("ics_files", [])
    config.setdefault("rules", [])

    for rule in config["rules"]:
        rule.setdefault("maximum_count", "")
        rule["start_date"] = parse_date(rule["start_date"])

    return config


def get_calendar_name(calendar) -> str:
    try:
        display_name = calendar.get_display_name()
        if display_name:
            return str(display_name)
    except Exception:
        pass

    return calendar.url.path.rstrip("/").split("/")[-1]


def read_ics_events(path: Path, start: datetime, end: datetime) -> list[dict]:
    if Calendar is None or recurring_ical_events is None:
        raise RuntimeError("Missing packages. Install with: pip install -r requirements.txt")

    cal = Calendar.from_ical(path.read_bytes())
    occurrences = recurring_ical_events.of(cal).between(start, end)

    events = []
    for item in occurrences:
        if item.name != "VEVENT":
            continue

        summary = str(item.get("summary", ""))
        dtstart = item.decoded("dtstart")
        events.append({
            "calendar": path.stem,
            "summary": summary,
            "start": normalize_dt(dtstart),
        })

    return events


def read_caldav_events(config: dict, start: datetime, end: datetime) -> list[dict]:
    if not config.get("url"):
        return []

    if caldav is None or Calendar is None:
        raise RuntimeError("Missing packages. Install with: pip install -r requirements.txt")

    client = caldav.DAVClient(
        url=config["url"],
        username=config.get("username") or os.environ.get("CALDAV_USERNAME"),
        password=config.get("password") or os.environ.get("CALDAV_PASSWORD"),
    )

    principal = client.principal()
    calendars = principal.calendars()
    wanted_names = set(config.get("calendar_names", []))

    events = []
    for calendar in calendars:
        name = get_calendar_name(calendar)

        if wanted_names and name not in wanted_names:
            continue

        for event in calendar.search(start=start, end=end, event=True, expand=True):
            cal = Calendar.from_ical(event.data)
            for item in cal.walk("VEVENT"):
                summary = str(item.get("summary", ""))
                dtstart = item.decoded("dtstart")
                events.append({
                    "calendar": name,
                    "summary": summary,
                    "start": normalize_dt(dtstart),
                })

    return events


def count_events(events: list[dict], rules: list[dict]) -> list[dict]:
    rows = []

    for rule in rules:
        count = sum(
            1
            for event in events
            if event["calendar"] == rule["calendar_name"]
            and exact_title_match(event["summary"], rule["event_name"])
            and event["start"] >= rule["start_date"]
        )

        rows.append({
            "Calendar name": rule["calendar_name"],
            "Event name": rule["event_name"],
            "Start date": rule["start_date"].date().isoformat(),
            "Current count": count,
            "Maximum count": rule["maximum_count"],
        })

    return rows


def print_table(rows: list[dict]) -> None:
    if not rows:
        print("No rows.")
        return

    headers = list(rows[0].keys())
    widths = {
        header: max(len(header), *(len(str(row[header])) for row in rows))
        for header in headers
    }

    print(" | ".join(header.ljust(widths[header]) for header in headers))
    print("-+-".join("-" * widths[header] for header in headers))

    for row in rows:
        print(" | ".join(str(row[header]).ljust(widths[header]) for header in headers))


def write_csv(rows: list[dict], path: Path) -> None:
    if not rows:
        return

    with path.open("w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
        writer.writeheader()
        writer.writerows(rows)


def main() -> int:
    parser = argparse.ArgumentParser(description="Count matching calendar events from ICS export or CalDAV.")
    parser.add_argument("--config", default="config.json", type=Path, help="Path to config.json")
    parser.add_argument("--csv", type=Path, help="Optional CSV output path")
    args = parser.parse_args()

    config = load_config(args.config)
    rules = config["rules"]

    if not rules:
        print("No rules found in config.", file=sys.stderr)
        return 2

    start = min(rule["start_date"] for rule in rules)
    end = today_utc()
    events = []

    for ics_file in config.get("ics_files", []):
        events.extend(read_ics_events(Path(ics_file), start, end))

    events.extend(read_caldav_events(config.get("caldav", {}), start, end))

    if not events:
        print("No calendar events loaded. Configure ics_files or caldav.url.", file=sys.stderr)
        return 2

    rows = count_events(events, rules)
    print_table(rows)

    if args.csv:
        write_csv(rows, args.csv)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
