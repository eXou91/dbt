-- Lire le fichier CSV depuis S3
SELECT *
FROM iceberg_scan('s3://iceberg/default/iceberg_election')

