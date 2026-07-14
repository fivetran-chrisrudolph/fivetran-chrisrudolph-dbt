# customer_reporting_consolidation

This project consolidates like-named raw tables from many tenant schemas in Snowflake into shared reporting-ready tables.

## Recommended production shape

- one dbt project
- shared macros and metadata
- lineage on every row: `tenant_id`, `source_server`, `source_database`, `source_schema`
- combined physical tables per entity, such as `orders_cmb`
- monitoring tables that show coverage and sync status by tenant

## What gets materialized where

- `stg_*` models are **views**. They union the raw tenant tables at query time.
- `int_*` models are **views**. They normalize raw identifiers and add stable keys.
- `*_cmb` tables are the customer-facing combined tables.
- monitoring marts like `order_tenant_coverage` are **tables**.

## Current working pattern

- `seeds/tenant_schemas.csv` maps tenant, server, database, and schema lineage.
- `models/staging/stg_all_orders.sql` unions raw `ft_table_0001` across enabled schemas.
- `models/intermediate/int_orders.sql` normalizes raw fields into reporting-safe names.
- `models/marts/orders_cmb.sql` is the combined physical orders table.
- `models/marts/order_tenant_coverage.sql` shows row counts and latest sync timestamp by tenant.

## How to access the combined data

The combined orders table is built as `orders_cmb` in your dbt target schema.

In this environment, that means you can query:

```sql
select *
from dbt_envestnet.orders_cmb
```

Common access patterns:

```sql
select *
from dbt_envestnet.orders_cmb
where tenant_id = 'zzz_sql01_ft_scale_db_0001'
```

```sql
select source_server, source_database, count(*)
from dbt_envestnet.orders_cmb
group by 1, 2
```

```sql
select *
from dbt_envestnet.order_tenant_coverage
order by max_fivetran_synced desc
```

For BI, point the semantic layer / BI tool at the combined tables in the target schema, not the raw per-tenant schemas.

## Scale recommendation

At your size, keep one project and partition processing by server or another operational boundary. Avoid one project per schema. Combined tables should eventually become incremental once the merge pattern is finalized.
