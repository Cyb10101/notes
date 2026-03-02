<?php
/*
Plugin Name: App Mail Verification
Plugin URI: https://github.com/Cyb10101/notes/tree/master/Programming/Websites/Wordpress/mu-plugins/app-mail-verification.php
Description: Control WordPress administration email verification prompt
Version: 2025.11.12
Author: Cyb10101
Author URI: https://cyb10101.de/
License: GPLv2 or later
License URI: https://www.gnu.org/licenses/gpl-2.0.html
*/

/*
Configure the admin email verification reminder.
WordPress prompts administrators every 6 months by default to confirm the site email.
This MU plugin switches the default to 24 months but lets you override or disable it.
On scripted deployments the popup can be disruptive, so adjust it per environment.
*/

// define('APP_ADMIN_EMAIL_CHECK_DISABLE', true); // Disable the reminder entirely
if (!defined('APP_ADMIN_EMAIL_CHECK_INTERVAL')) {
    define('APP_ADMIN_EMAIL_CHECK_INTERVAL', MONTH_IN_SECONDS * 24); // Reminder interval in seconds
}

class AppMailVerification {
    public function initialize() {
        add_filter('admin_email_check_interval', [$this, 'adminEmailCheckInterval'], 10, 1);
    }

    public function adminEmailCheckInterval($interval) {
        if (defined('APP_ADMIN_EMAIL_CHECK_DISABLE') && APP_ADMIN_EMAIL_CHECK_DISABLE) {
            return false;
        }

        if (defined('APP_ADMIN_EMAIL_CHECK_INTERVAL') && is_numeric(APP_ADMIN_EMAIL_CHECK_INTERVAL)) {
            return (int)APP_ADMIN_EMAIL_CHECK_INTERVAL;
        }

        return $interval;
    }
}

(new AppMailVerification())->initialize();
