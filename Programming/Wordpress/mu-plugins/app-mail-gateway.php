<?php
/*
Plugin Name: App Mail Gateway
Plugin URI: https://github.com/Cyb10101/notes/tree/master/Programming/Wordpress/mu-plugins/app-mail-gateway.php
Description: Configure outgoing mails
Version: 2026.03.05
Author: Cyb10101
Author URI: https://cyb10101.de/
License: GPLv2 or later
License URI: https://www.gnu.org/licenses/gpl-2.0.html
*/

if (!defined('ABSPATH')) {
    exit(); // Exit if accessed directly
}

/*
Add mail configuration to wp-config.php.

## SMTP (Recommended minimal setup)
// Mail configuration, see mu-plugins/app-mail-gateway.php
define('MAIL_FROM', 'info@example.com');     // Optional: Overrides the default sender email
define('MAIL_FROM_NAME', 'Example Webpage'); // Optional: Overrides the default sender name
define('MAIL_DSN', 'smtps://username:password@smtp.example.com:465?encryption=ssl&auth=true');

## Google - Generate a App Password: https://myaccount.google.com/apppasswords
define('MAIL_FROM', 'username@gmail.com');   // Required
define('MAIL_FROM_NAME', 'Example Webpage'); // Optional: Overrides the default sender name
define('MAIL_DSN', 'smtp://' . MAIL_FROM . ':app-password@smtp.gmail.com:587?encryption=tls&auth=true');

## Development
define('MAIL_DSN', 'smtp://global-mail:1025');

## Alternative DSN variants
define('MAIL_DSN', 'smtp+ssl://username:password@smtp.example.com:465');
define('MAIL_DSN', 'smtps://username:password@smtp.example.com:465');
define('MAIL_DSN', 'smtp://username@smtp.example.com:25?auth=false');

## Send test mail via WP-CLI
wp-cli --path='public' eval "var_dump(wp_mail('user@example.com', 'Mail test', date('Y-m-d H:i:s') . ' It works'));"
*/

class AppMailGateway {
    public function initialize() {
        add_action('phpmailer_init', [$this, 'phpmailerInit'], PHP_INT_MAX);
        add_filter('wp_mail_from', [$this, 'wpMailFrom'], PHP_INT_MAX);
        add_filter('wp_mail_from_name', [$this, 'wpMailFromName'], PHP_INT_MAX);
    }

    public function phpmailerInit(\PHPMailer\PHPMailer\PHPMailer $phpmailer) {
        $config = $this->resolveSmtpConfig();

        if ($config === null) {
            return;
        }

        // Configure SMTP
        $phpmailer->isSMTP();
        $phpmailer->Host = $config['host'];

        if ($config['port'] !== null) {
            $phpmailer->Port = (int)$config['port'];
        }

        $phpmailer->SMTPAuth = $config['auth'];

        if ($config['username'] !== '') {
            $phpmailer->Username = $config['username'];
        }
        if ($config['password'] !== '') {
            $phpmailer->Password = $config['password'];
        }

        if ($config['secure'] !== '') {
            $secure = strtolower((string)$config['secure']);
            if ($secure === 'tls') {
                $phpmailer->SMTPSecure = \PHPMailer\PHPMailer\PHPMailer::ENCRYPTION_STARTTLS;
            } else if ($secure === 'ssl') {
                $phpmailer->SMTPSecure = \PHPMailer\PHPMailer\PHPMailer::ENCRYPTION_SMTPS;
            } else {
                // Allow raw constant usage (e.g. PHPMailer::ENCRYPTION_SMTPS)
                $phpmailer->SMTPSecure = $config['secure'];
            }
        }

        // Set from mail and name
        $from = apply_filters('wp_mail_from', get_option('admin_email'));
        $fromName = apply_filters('wp_mail_from_name', wp_specialchars_decode(get_bloginfo('name'), ENT_QUOTES));
        try {
            $phpmailer->setFrom($from, $fromName, false);
        } catch (Exception $exception) {
            // Fallback if invalid from
        }
    }

    public function wpMailFrom($mail) {
        return defined('MAIL_FROM') && is_email(MAIL_FROM) ? MAIL_FROM : $mail;
    }

    public function wpMailFromName($name) {
        return defined('MAIL_FROM_NAME') ? MAIL_FROM_NAME : $name;
    }

    /**
     * Resolve SMTP configuration from the MAIL_DSN definition.
     */
    private function resolveSmtpConfig(): ?array {
        if (!defined('MAIL_DSN') || MAIL_DSN === '') {
            return null;
        }

        $dsn = $this->parseMailerDsn(MAIL_DSN);
        if ($dsn === null || $dsn['host'] === '') {
            return null;
        }

        $config = [
            'host' => $dsn['host'],
            'port' => $dsn['port'],
            'username' => $dsn['user'],
            'password' => $dsn['pass'],
            'secure' => '',
            'auth' => null,
        ];

        $transport = $dsn['transport'];
        if ($transport !== '') {
            if (strpos($transport, 'smtp+ssl') === 0 || $transport === 'smtps') {
                $config['secure'] = 'ssl';
            } else if (strpos($transport, 'smtp+tls') === 0) {
                $config['secure'] = 'tls';
            }
        }

        if (!empty($dsn['options'])) {
            $options = array_change_key_case($dsn['options'], CASE_LOWER);
            if (!empty($options['encryption'])) {
                $config['secure'] = (string)$options['encryption'];
            }
            if (isset($options['auth']) && $options['auth'] !== '') {
                $auth = filter_var($options['auth'], FILTER_VALIDATE_BOOLEAN, FILTER_NULL_ON_FAILURE);
                if ($auth !== null) {
                    $config['auth'] = $auth;
                }
            }
        }

        if ($config['auth'] === null) {
            $config['auth'] = ($config['username'] !== '' || $config['password'] !== '');
        }

        return $config;
    }

    /**
     * Parse a mailer DSN into components.
     *
     * Supported format (Symfony style):
     *  smtp://user:pass@smtp.example.com:587?encryption=tls&auth=true
     *
     * Returns an array with keys: transport, host, port, user, pass, options.
     */
    private function parseMailerDsn(string $dsn = ''): ?array {
        $dsn = trim($dsn);
        if ($dsn === '') {
            return null;
        }

        $parts = parse_url($dsn);
        if ($parts === false) {
            return null;
        }

        $result = [
            'transport' => '',
            'host' => '',
            'port' => null,
            'user' => '',
            'pass' => '',
            'options' => [],
        ];

        if (!empty($parts['scheme'])) {
            $result['transport'] = strtolower($parts['scheme']);
        }

        if (!empty($parts['host'])) {
            $result['host'] = $parts['host'];
        }

        if (!empty($parts['port'])) {
            $port = (int)$parts['port'];
            if ($port >= 1 && $port <= 65535) {
                $result['port'] = $port;
            }
        }

        if (!empty($parts['user'])) {
            $result['user'] = urldecode($parts['user']);
        }

        if (!empty($parts['pass'])) {
            $result['pass'] = urldecode($parts['pass']);
        }

        if (!empty($parts['query'])) {
            parse_str($parts['query'], $query);
            if (is_array($query)) {
                $result['options'] = $query;
            }
        }

        return $result;
    }
}

(new AppMailGateway())->initialize();
