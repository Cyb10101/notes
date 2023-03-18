# Convert csv to json

Test in development:

```bash
go run csv2json.go input.csv output.json
```

Compile and move to binary folder:

```bash
# Linux
sudo go build -o /usr/local/bin/csv2json -buildvcs=false

# Windows
env GOOS=windows GOARCH=amd64 go build
```

Execute:

```bash
# Convert export.csv to export.json
csv2json export.csv

# Convert input.csv to output.json
csv2json input.csv output.json

# Convert input.csv to output.json with semikolon as demiliter
csv2json -comma ';' input.csv output.json
```

## Other

* [JQ](https://stedolan.github.io/jq/download/)

Get a single value by JQ.

```bash
# Linux
jq -r '.rows | map(."E-mail Address" | select(length > 0)) | join(",\n")' input.json > email.txt

# Windows
jq -r ".rows | map(.\"E-mail Address\" | select(length > 0)) | join(\",\n\")" input.json > email.txt
```
