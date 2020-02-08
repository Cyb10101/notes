SELECT table_schema "Database",
	CONCAT(ROUND(SUM(data_length + index_length) / 1024 / 1024, 2), ' MB') "Size",
	CONCAT(ROUND(SUM(data_free) / 1024 / 1024, 2), ' MB') "Free Space"
	FROM information_schema.TABLES GROUP BY table_schema;
