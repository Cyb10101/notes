<?php
/*
Plugin Name: App Comment IP
Plugin URI: https://github.com/Cyb10101/notes/tree/master/Programming/Websites/Wordpress/mu-plugins/app-comment-ip.php
Description: Remove comment IP addresses immediately or after a configurable retention period.
Version: 2026.03.05
Author: Cyb10101
Author URI: https://cyb10101.de/
License: GPLv2 or later
License URI: https://www.gnu.org/licenses/gpl-2.0.html
*/

if (!defined('ABSPATH')) {
    exit();
}

// Add in wp-config.php or here:
// define('APP_COMMENT_IP_RETENTION_DAYS', 0); // Default, remove all IP addresses from comments directly without scheduler
// define('APP_COMMENT_IP_RETENTION_DAYS', 7); // Remove ip addresses after 7 days (DSVGO)

final class AppCommentIP {
    private const DEFAULT_RETENTION_DAYS = 0;
    private const CRON_HOOK = 'app_comment_ip_cleanup';

    public static function initialize(): void {
        add_filter('pre_comment_user_ip', [self::class, 'filterCommentIp'], PHP_INT_MAX);
        add_action('init', [self::class, 'cronSyncSchedule']);
        add_action(self::CRON_HOOK, [self::class, 'cronCleanupComments']);
    }

    public static function filterCommentIp(string $ip): string {
        return self::getRetentionDays() === 0 ? '' : $ip;
    }

    public static function cronSyncSchedule(): void {
        $scheduled = wp_next_scheduled(self::CRON_HOOK);

        if (self::getRetentionDays() > 0) {
            if (!$scheduled) {
                wp_schedule_event(time() + HOUR_IN_SECONDS, 'daily', self::CRON_HOOK);
            }
            return;
        }

        if ($scheduled) {
            wp_clear_scheduled_hook(self::CRON_HOOK);
        }
    }

    public static function cronCleanupComments(): void {
        if (self::getRetentionDays() === 0) {
            return;
        }

        global $wpdb;

        $cutoff = gmdate('Y-m-d H:i:s', time() - (self::getRetentionDays() * DAY_IN_SECONDS));

        $wpdb->query(
            $wpdb->prepare(
                "UPDATE {$wpdb->comments} SET comment_author_IP = '' WHERE comment_author_IP <> '' AND comment_date_gmt < %s", $cutoff
            )
        );
    }

    private static function getRetentionDays(): int {
        return max(0, (int) self::getConfigValue('APP_COMMENT_IP_RETENTION_DAYS', self::DEFAULT_RETENTION_DAYS));
    }

    private static function getConfigValue(string $constant, $default) {
        return defined($constant) ? constant($constant) : $default;
    }
}

AppCommentIP::initialize();
