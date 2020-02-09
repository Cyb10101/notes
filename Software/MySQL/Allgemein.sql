/* Copy column to another column */
UPDATE `{table}` SET `{column1}` = CONCAT(`{column2}`, ' (Copy)');
UPDATE `{table}` SET `{column1}` = CONCAT('Text for ', DATE_FORMAT(`{columnDate}`, "%d.%m.%Y"));

/* Show standard character set */
SELECT @@character_set_database, @@collation_database;

/* SQL query to create a database in UTF8 */
CREATE DATABASE `{database}` CHARACTER SET UTF8;
CREATE DATABASE `{database}` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

/* Console - Export database to UTF8: (untested) */
/* $ mysqldump {database} --default-character-set=UTF8 > {file}.sql */

/* Console - Import database into UTF8 */
/* $ mysql {database} --default-character-set=UTF8 < {file}.sql */

/* MySQL UTF-8 fields fix with doubled encoding (untested) */
UPDATE users SET name = CONVERT(CAST(CONVERT(name USING latin1) AS BINARY) USING utf8);

/* Variable: Select & Insert */
SET @pid = 123;
TRUNCATE `{table}`;

SELECT @countryUid := `uid` FROM `static_countries` WHERE `cn_iso_2` = 'AT';
INSERT INTO `{table}` (pid, country, vat) VALUES (@pid, @countryUid, 20);

/* Fix Table - In case of broken Uid move & recreate (RENAME, CREATE, INSERT) */
RENAME TABLE `{old-table}` TO `{new-table}`;
/* -> "CREATE" Schema heraus holen, Auto_Increment entfernen & Tabelle neu anlegen */
INSERT INTO `{new-clean-table}` (`{column2}`, `{column3}`) SELECT `{column2}`, `{column3}` FROM `{old-corrupt-table}` WHERE `deleted` = 0;

/* Copy table */
INSERT INTO `newTable` (`column2`, `column3`) SELECT `column2`, `column3` FROM `oldTable`;

/* Find duplicates */
SELECT * FROM `tabelle` WHERE `column` != '' GROUP BY `column` HAVING COUNT(*) > 1;

/* Find and display duplicates */
SELECT uid, pid, deleted, hidden, `number` FROM `tabelle` WHERE number IN (
  SELECT number FROM `tabelle` WHERE `number` != '' GROUP BY `number` HAVING COUNT(*) > 1
) ORDER BY `number` ASC, `uid` ASC;

/* Find in comma seperated list and add one */
SELECT `uid`,  `pid`,  `fe_group` FROM `pages` WHERE FIND_IN_SET(1, `fe_group`) > 0 && FIND_IN_SET(2, `fe_group`) = 0;
UPDATE `pages` SET `fe_group` = CONCAT(`fe_group`, ',2') WHERE FIND_IN_SET(1, `fe_group`) > 0 && FIND_IN_SET(2, `fe_group`) = 0;

/* MySQL unicode - U+009C in Hexadeximal: c29c
 * ExtBase PHP: $query->like('column', '%test' . hex2bin('c29c') . 'test%');
 */
SELECT * FROM `table` WHERE `column` LIKE CONCAT('%test', UNHEX('c29c'), 'test%');
