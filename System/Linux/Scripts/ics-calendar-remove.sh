#!/usr/bin/env bash
# ./ics-calendar-remove.sh input.ics output.ics 'SUMMARY:Bring trash out'

inputFile="${1}"
outputFile="${2}"
find="${3}"

if [ ! -f "$inputFile" ]; then
  echo "Error: Input file not found!"; exit 1;
fi
if [ -z "$outputFile" ]; then
  echo "Error: Output file not specified!"; exit 1;
fi
if [ -z "$find" ]; then
  echo "Error: Search parase empty!"; exit 1;
fi

echo "# Removing '$find' ..."
tmpFolder=`mktemp -d "cal_XXXXXXXX"`
totalFiles=`csplit --prefix="${tmpFolder}/cal" --digits=5 "$inputFile" '/BEGIN:VEVENT/' '{*}' | wc -l`

if [ $totalFiles -gt 0 ]; then
  grep -lri "$find" "$tmpFolder" | xargs -I '{}' rm '{}'
  find "$tmpFolder/" -type f | sort | xargs -L 1 cat > "$outputFile"
  remainingEvents=`find "$tmpFolder/" -type f | wc -l`

  echo "Total events: $totalFiles | Remaining events: $remainingEvents"
else
  echo 'Error: No events found!'
fi

rm -r "$tmpFolder"
