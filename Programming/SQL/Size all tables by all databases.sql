/* Die größten Tabellen von allen Datenbank anzeigen */
SELECT `table_schema` "Database", `table_name` "Table",
    CONCAT(ROUND(table_rows / 1000000, 2), 'M') Rows,
    CONCAT(ROUND(data_length / (1024 * 1024 * 1024), 2), 'G') Data,
    CONCAT(ROUND(index_length / (1024 * 1024 * 1024), 2), 'G') idx,
    CONCAT(ROUND((data_length + index_length) / (1024 * 1024 * 1024), 2), 'G') Total_Size,
    ROUND(index_length / data_length, 2) idx_frac
FROM information_schema.TABLES ORDER BY Total_Size DESC LIMIT 10;
