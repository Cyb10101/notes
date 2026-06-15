# Calendar Count Events

Counts calendar events.

## Run

```bash
./run.sh --config config.json

# Save as CSV
./run.sh --config config.json --csv counts.csv
```

## Run with ICS export

```bash
python3 count_calendar_events.py --config config.json
```

The calendar name is taken from the ICS filename without `.ics`:

```text
General.ics -> General
Work.ics    -> Work
```

## Run with CalDAV

You can also leave `username` and `password` empty and use environment variables:

```bash
export CALDAV_USERNAME="your-user-name"
export CALDAV_PASSWORD="your-app-password"
python3 count_calendar_events.py --config config.json
```
