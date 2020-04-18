# Split files in folder

Split a `folder` with 6000 files to seperate folder like:

* folder_1 (5000 files)
* folder_2 (1000 files)

Compile and move to binary folder:

```bash
go build
sudo mv split-files /usr/local/bin/
```

Execute:

```bash
split-files -max 1000 directory
split-files -max 1000 -addfolder '0-viewed' directory
```
