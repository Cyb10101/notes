# XAMPP

* [XAMPP](https://www.apachefriends.org/)

## Add Virtual Hosts (vHosts)

Edit vHosts `C:\xampp\apache\conf\extra\httpd-vhosts.conf`:

```apache
<VirtualHost *:80>
    ServerName example.localhost
    DocumentRoot "C:/xampp/htdocs/example_www/public"

    <Directory "C:/xampp/htdocs/example_www">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
<VirtualHost *:443>
    ServerName example.localhost
    DocumentRoot "C:/xampp/htdocs/example_www/public"

    SSLEngine on
    SSLCertificateFile "C:/xampp/apache/conf/ssl.crt/server.crt"
    SSLCertificateKeyFile "C:/xampp/apache/conf/ssl.key/server.key"

    <Directory "C:/xampp/htdocs/example_www">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>

<VirtualHost *:80>
    ServerName forum.example.localhost
    DocumentRoot "C:/xampp/htdocs/example_forum/public"
    <Directory "C:/xampp/htdocs/example_forum/public">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
<VirtualHost *:443>
    ServerName forum.example.localhost
    DocumentRoot "C:/xampp/htdocs/example_forum/public"

    SSLEngine on
    SSLCertificateFile "C:/xampp/apache/conf/ssl.crt/server.crt"
    SSLCertificateKeyFile "C:/xampp/apache/conf/ssl.key/server.key"

    <Directory "C:/xampp/htdocs/example_forum/public">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
```

Open Notepad as Administator, open file `C:\Windows\System32\drivers\etc\hosts` and add hosts:

```text
127.0.0.1 example.local
127.0.0.1 forum.example.local
```
