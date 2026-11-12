{% macro build_combined_ft_table(table_name) %}
with base as (
    {{ union_tenant_table(table_name) }}
)

select
    md5(
        concat(
            coalesce(cast(TENANT_ID as {{ dbt.type_string() }}), '_dbt_null_'),
            '||',
            coalesce(cast(SOURCE_SERVER as {{ dbt.type_string() }}), '_dbt_null_'),
            '||',
            coalesce(cast(SOURCE_DATABASE as {{ dbt.type_string() }}), '_dbt_null_'),
            '||',
            coalesce(cast("id" as {{ dbt.type_string() }}), '_dbt_null_')
        )
    ) as record_sk,
    TENANT_ID as tenant_id,
    SOURCE_SERVER as source_server,
    SOURCE_DATABASE as source_database,
    SOURCE_SCHEMA as source_schema,
    "id" as record_id,
    "_fivetran_deleted" as is_fivetran_deleted,
    "_fivetran_synced" as fivetran_synced_at
from base
{% endmacro %}
