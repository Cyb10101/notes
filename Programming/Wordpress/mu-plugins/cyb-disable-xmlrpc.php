<?php
/*
Plugin Name: Cyb Disable XML-RPC
Plugin URI: https://github.com/Cyb10101/notes/tree/master/Programming/Wordpress/mu-plugins/cyb-disable-xmlrpc.php
Description: Disable XML-RPC in WordPress
Version: 2026.03.03
Author: Cyb10101
Author URI: https://cyb10101.de/
License: GPLv2 or later
License URI: https://www.gnu.org/licenses/gpl-2.0.html
*/

/*
This plugin disables XML-RPC at WordPress application level via the `xmlrpc_enabled` filter.
Keeping XML-RPC enabled increases attack surface, especially for brute-force and amplification-style abuse on /xmlrpc.php.


Disabling XML-RPC makes the following unavailable:

- Remote publishing clients
- Jetpack XML-RPC calls
- Legacy WordPress mobile app flow

## Defense in depth (recommended)

Also block xmlrpc.php in Apache 2.4 so requests are denied before PHP executes (/.htaccess):

<Files "xmlrpc.php">
  Require all denied
</Files>
*/

if (!defined('ABSPATH')) {
    exit(); // Exit if accessed directly
}

add_filter('xmlrpc_enabled', '__return_false', PHP_INT_MAX);
