-- models/load_parquet_with_s3_config.sql

-- Lire le fichier Parquet depuis S3

SELECT 
    sum(Abstentions) AS sum_abs, 
    id_election 
FROM {{ ref('load_iceberg') }}
GROUP BY id_election 
ORDER BY sum_abs 
