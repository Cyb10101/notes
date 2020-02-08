/* Find all plugins in relation to pages */
SELECT c.`uid`, c.`pid`, c.`header`, c.`list_type`
FROM `tt_content` AS c LEFT JOIN `pages` AS p ON (c.`pid` = p.`uid`)
WHERE c.`list_type` LIKE '%cybextension_plugin%'
AND c.`deleted` = 0 AND c.`hidden` = 0 AND p.`deleted` = 0 AND p.`hidden` = 0
ORDER BY `pid` ASC, `uid` ASC;

/* Find just all plugins */
SELECT DISTINCT `uid`, `pid`, `list_type` FROM `tt_content` WHERE `list_type` LIKE '%cybextension_plugin%' AND `deleted` = 0 AND `hidden` = 0 ORDER BY `pid` ASC, `uid` ASC;
