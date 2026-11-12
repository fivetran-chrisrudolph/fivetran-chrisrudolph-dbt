{{ config(materialized='view') }}

with base as (
    select *
    from {{ ref('stg_all_orders') }}
)

select
    md5(
        concat(
            coalesce(cast(base.TENANT_ID as {{ dbt.type_string() }}), '_dbt_null_'),
            '||',
            coalesce(cast(base.SOURCE_SERVER as {{ dbt.type_string() }}), '_dbt_null_'),
            '||',
            coalesce(cast(base.SOURCE_DATABASE as {{ dbt.type_string() }}), '_dbt_null_'),
            '||',
            coalesce(cast(base."id" as {{ dbt.type_string() }}), '_dbt_null_')
        )
    ) as order_sk,
    base.TENANT_ID as tenant_id,
    base.SOURCE_SERVER as source_server,
    base.SOURCE_DATABASE as source_database,
    base.SOURCE_SCHEMA as source_schema,
    base."id" as order_id,
    base."_fivetran_deleted" as is_fivetran_deleted,
    base."_fivetran_synced" as fivetran_synced_at
from base
