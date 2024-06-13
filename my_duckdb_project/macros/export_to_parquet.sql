{% macro export_partition_data(table, path) %}
{% set s3_path = env_var('TRANSFORM_S3_PATH_OUTPUT', 's3://duckdb') %}
COPY (
    SELECT *
    FROM {{ table }}
) 
TO '{{ s3_path }}/{{ path }}'
 (FORMAT PARQUET, OVERWRITE_OR_IGNORE 1);
{% endmacro %}
