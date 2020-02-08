SELECT COUNT(1) as `counter`, `tablename`, `details`, `log_data` FROM `sys_log` GROUP BY `details` ORDER BY `counter` DESC;
