# Fonts

## Convert Fonts: OTF to TTF

```bash
sudo apt install fontforge
```

Create script `otf2ttf.sh`:

```bash
#!/usr/local/bin/fontforge
# Quick and dirty hack: Converts a font to truetype (.ttf)
Print("Opening "+$1);
Open($1);
Print("Saving "+$1:r+".ttf");
Generate($1:r+".ttf");
Quit(0);
```

Create script `convert-otf-to-ttf.sh`:

```bash
#!/usr/bin/env bash
for file in *.otf; do fontforge -script otf2ttf.sh $file; done
```
