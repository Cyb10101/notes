<?php
/*
Plugin Name: Cyb Mail Verification
Plugin URI: https://github.com/Cyb10101/notes/tree/master/Programming/Wordpress/mu-plugins/cyb-mail-verification.php
Description: Control WordPress administration email verification prompt
Version: 2026.03.05
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

// define('CYB_ADMIN_EMAIL_CHECK_DISABLE', true); // Disable the reminder entirely
if (!defined('CYB_ADMIN_EMAIL_CHECK_INTERVAL')) {
    define('CYB_ADMIN_EMAIL_CHECK_INTERVAL', MONTH_IN_SECONDS * 24); // Reminder interval in seconds
}

class CybMailVerification {
    public function initialize() {
        add_filter('admin_email_check_interval', [$this, 'adminEmailCheckInterval'], 10, 1);
    }

    public function adminEmailCheckInterval($interval) {
        if (defined('CYB_ADMIN_EMAIL_CHECK_DISABLE') && CYB_ADMIN_EMAIL_CHECK_DISABLE) {
            return false;
        }

        if (defined('CYB_ADMIN_EMAIL_CHECK_INTERVAL') && is_numeric(CYB_ADMIN_EMAIL_CHECK_INTERVAL)) {
            return (int)CYB_ADMIN_EMAIL_CHECK_INTERVAL;
        }

        return $interval;
    }
}

(new CybMailVerification())->initialize();
