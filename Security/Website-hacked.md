# Website hacked

## Add maintenance site

Apache:

```text
# Cleaning up your Website apache
RewriteEngine On
RewriteCond %{REQUEST_URI} !=/maintenance.html
RewriteRule ^ /maintenance.html [L,R=302]
```

Nginx:

```text
# Cleaning up your Website nginx
location / {
    if (-f $document_root/maintenance.html) {
        return 503;
    }
}

error_page 503 @maintenance;
location @maintenance {
    rewrite ^(.*)$ /maintenance.html break;
}
```

## Find suspicious code in files

```bash
# Find all images
find -name '*' -exec file {} \; | grep -o -P '^.+: \w+ image'

# Find no images
find -name '*' -exec file {} \; | grep -v -o -P '^.+: \w+ image'

# Finding Recently Modified PHP Files (mtime in days)
find -type f -name '*.php' -mtime -7
find public/upload -type f -name '*.php'

# Search all PHP Files for suspicious code
find -type f -name '*.php' | xargs egrep -in --color "(str_rot13|hex2bin|chr|hexdec|gzinflate) *\("
find -type f -name '*.php' | xargs egrep -in --color "([^A-Za-z]mail|fsockopen|pfsockopen|stream_socket_client|[^_]exec|[^A-Za-z]system|passthru|[^_]eval) *\("
find -type f -name '*.php' | xargs egrep -in --color "(base64_decode|base64_encode) *\("

find -type f | xargs egrep -ina --color "(str_rot13|hex2bin|chr|hexdec|gzinflate) *\("
find -type f | xargs egrep -ina --color "([^A-Za-z]mail|fsockopen|pfsockopen|stream_socket_client|[^_]exec|[^A-Za-z]system|passthru|[^_]eval) *\("
find -type f | xargs egrep -ina --color "(base64_decode|base64_encode) *\("

find -type f -name '*.php' | xargs egrep -in --color "preg_replace *\((['|\"])(.).*\2[a-z]*e[^\1]*\1 *,"

find -type f -name '.htaccess' | xargs egrep -in --color "(auto_prepend_file|auto_append_file|http)"

# Compare directories and exclude wp-content
diff -x wp-content -r wordpress-clean/ wordpress-compromised/

# Clear cache (Symfony)
./bin/console cache:clear --no-warmup
./bin/console cache:warmup
./bin/console cache:pool:clear --env=dev
rm -rf var/cache/dev

# Find PHP in non PHP files
find -type f -not -iname '*.php' -print0 | xargs -0 egrep -in --color "(<\?php|<\?=|<\? *(?!(xml)))"
find -type f -not -iname '*.php' -print0 | xargs -0 egrep -in --color --text "(<\?php|<\?=|<\? *(?!(xml)))"

# Find text 'php' in files
find -type f | xargs grep -i php
find -type f -iname '*.jpg' | xargs grep -i php
```

## Find suspicious code in database

```sql
SELECT * FROM `website_www`.`options` WHERE LOWER(CONVERT(`value` USING utf8mb4)) REGEXP '(str_rot13|hex2bin|chr|hexdec|gzinflate) *\\(';

SELECT * FROM `website_www`.`options` WHERE `value` LIKE '%select%';
SELECT * FROM `website_www`.`options` WHERE `value` LIKE '%base64_%';
SELECT * FROM `website_www`.`options` WHERE `value` LIKE '%eval(%';
```
