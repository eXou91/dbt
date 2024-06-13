-- Lire le fichier CSV depuis S3
SELECT *
FROM read_csv('s3://test/general_results.csv')
