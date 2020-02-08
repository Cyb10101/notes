/* Die größten Tabellen einer Datenbank anzeigen */
SELECT table_name AS "Table", CONCAT(ROUND((data_length + index_length) / (1024 * 1024 * 1024), 2), 'G') Total_Size FROM information_schema.TABLES
WHERE table_schema = "{DATABASE}" ORDER BY Total_Size DESC LIMIT 10;
