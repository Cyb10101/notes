## Image Magick

Errors:

```text
convert-im6.q16: cache resources exhausted `file' @ error/cache.c/OpenPixelCache/4083.

convert-im6.q16: attempt to perform an operation not allowed by the security policy `PDF' @ error/constitute.c/IsCoderAuthorized/408.
```

Fix:

```bash
convert --version
sudo gedit /etc/ImageMagick-6/policy.xml
```

```xml
<!-- <policy domain="resource" name="disk" value="1GiB"/> -->
<policy domain="resource" name="disk" value="16GiB"/>

<!-- <policy domain="coder" rights="none" pattern="PDF" /> -->
<policy domain="coder" rights="read | write" pattern="PDF" />
```
