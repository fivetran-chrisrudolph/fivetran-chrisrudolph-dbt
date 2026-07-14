{{ config(materialized='table') }}

select
    tenant_id,
    source_server,
    source_database,
    source_schema,
    count(*) as order_row_count,
    max(fivetran_synced_at) as max_fivetran_synced
from {{ ref('int_orders') }}
where coalesce(is_fivetran_deleted, false) = false
group by 1, 2, 3, 4
