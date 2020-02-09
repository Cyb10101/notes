# .htaccess

## Redirect: none-www to www

```apacheconf
# none-www nach www
RewriteCond %{HTTP_HOST} !^www\.
RewriteRule (.*) https://www.%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
```

## Redirect: http to https

```apacheconf
# http to http redirect
RewriteCond %{HTTPS} off
# port ist optional
# RewriteCond %{SERVER_PORT} 80
RewriteRule (.*) https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
```

## TYPO3 in the root directory of a project

```apacheconf
# TYPO3 Security
<FilesMatch "^(Gruntfile\.js|composer\.json|composer\.lock|\.gitignore|node_modules|package\.json|(.*)\.sql|(.*)\.ts|(.*)\.3ts|(.*)\.md|(.*)\.rst|(.*)\.log|(.*)\.yml|(.*)\.phar)$">
	Order allow,deny
	Deny from all
</FilesMatch>
RewriteEngine On
RewriteRule ^(.*)typo3_src/ - [F]
RewriteRule ^(.*)Resources/Private/ - [F]
RewriteRule ^(.*)Configuration/TCA/ - [F]
RewriteRule ^(.*)Configuration/TypoScript/ - [F]
```

## TYPO3 im Extension-Verzeichnis

```apacheconf
deny from all
```

This file should be in the TYPO3 extension:

* Configuration/.htaccess
* Resources/Private/.htaccess

## .htpasswd - Create a password (better)

```bash
# Nginx, soll besser sein
printf "{Username}: `openssl passwd -apr1`\n" >> /etc/nginx/htpasswd-{ProjectId}-{ProjectName}

# Apache & Nginx
htpasswd -c /etc/nginx/htpasswd-{ProjectId}-{ProjectName} {username}
```

## Password and IP protection

```apacheconf
# No password required for domains
SetEnvIf Host domain.de noPasswordRequired
```

### No password required for ip & hostname

```apacheconf
Require ip 123.123.123.123
Require host pc-dev
```

### Authentication with username and password

```apacheconf
AuthName "Login"
<If "%{HTTP_HOST} != 'domain.de'">
    AuthUserFile /shared/dev/htdocs/.htpasswd
</If>
<Else>
    AuthUserFile /shared/live/htdocs/.htpasswd
</Else>
AuthType Basic
Require valid-user
```

### Authentication rules

```apacheconf
Order Deny,Allow
Deny from all
Allow from env=noPasswordRequired
Satisfy Any
```

### Password protection for folders

Password protection for folders (admin|secure) but not for set IP.

```apacheconf
SetEnvIf REQUEST_URI "^/(admin|secure)/" PROTECTED

<RequireAny>
    <RequireAll>
        # Environment can do anything except PROTECTED
        Require not env PROTECTED
        Require all granted
    </RequireAll>
    <RequireAll>
        # Ip can do anything
        Require ip 10.50.1.151
    </RequireAll>
    <RequireAll>
        # Host can do anything
        Require host cyb-blue
    </RequireAll>
    <RequireAll>
        # Password for rest
        AuthType Basic
        AuthName "Password Protected"
        AuthUserFile /var/www/html/.htpasswd
        Require valid-user
    </RequireAll>
</RequireAny>
```

### User example

```apacheconf
AuthType Basic
AuthBasicProvider file
#AuthUserFile /var/www/example/www/public/.htpasswd
AuthName "Access to the private site"
<RequireAll>
  Require valid-user
</RequireAll>
```

Create password:

```bash
# bcrypt
htpasswd -cB .htpasswd user

# md5 - default
htpasswd -cm .htpasswd user
```
