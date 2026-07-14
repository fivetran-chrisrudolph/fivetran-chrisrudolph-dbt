{{ config(materialized='view') }}

{{ union_tenant_table('ft_table_0001') }}

