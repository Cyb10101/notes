/* Solution for incorrectly displayed characters
 * If you see such characters in the database, it probably crashed slightly during the database import:
 * [Error     | Correct]
 * Ãœberblick | Überblick
 * fÃ¼r       | für
 * LÃ¶sungen  | Lösungen
 */

/* 1. Generate database update SQL commands
 * First you have to check whether the database is in UTF8 and which tables are latin1.
 * These are then changed as a table name (TABLE_NAME) in the SQL command.
 * In addition, the database name (TABLE_SCHEMA) must be specified.
 * This command can be used to generate the update commands that will be needed later:
 */

/* MySQL - Befehl für die Query Befehle */
SELECT CONCAT('UPDATE `', `TABLE_NAME`, '` SET `', `COLUMN_NAME`, '` = CONVERT(binary CONVERT(`', `COLUMN_NAME`, '` using latin1) using utf8);') as Commands FROM (
	SELECT `TABLE_NAME`, `COLUMN_NAME`, `COLLATION_NAME` FROM `information_schema`.`COLUMNS` WHERE `TABLE_SCHEMA` = '{database}' AND `COLLATION_NAME` LIKE 'latin%' AND
		(
			`TABLE_NAME` = '{table1}' OR
			`TABLE_NAME` = '{table2}' OR
			`TABLE_NAME` = '{table3}'
		)
) AS Info;

/* Have the update commands output and export.
 * If PhpMyAdmin is used, you should click on the "Print view (full text fields)"
 * toggle and make sure to remove the "Command" line.
 *
 * @todo Translate
 * Die Update Befehle ausgeben lassen und exportieren.
 * Falls PhpMyAdmin verwendet wird, sollte man auf die "Druckansicht (vollständige Textfelder)"
 * umschalten und darauf achten, dass man die Zeile "Command" entfernt.
 */

/* 2. Now the respective tables can be converted to UTF8 */
ALTER TABLE `{table}` CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;

/* 3. Convert database fields
 * Finally, the previous update commands are carried out in step 1, after which the characters should fit again.
 *
 * @todo Translate
 * Als letztes werden die vorherigen Update Befehle im 1. Schritt ausgeführt, danach sollten die Zeichen wieder passen.
 */

/* Convert a column */
UPDATE `{table}` SET `{column}` = CONVERT(binary CONVERT(`{column}` using latin1) using utf8);
