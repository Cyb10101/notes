# Composer

```bash
# Status verbose
composer status -v

composer install --ignore-platform-reqs
```

## composer.json

No more `composer dump-autoload -o` by` optimize-autoloader`.

Allow http by disabling `secure-http` (not recommended).

```json
{
  "config": {
    "secure-http": false,
    "optimize-autoloader": true
  }
}
```
