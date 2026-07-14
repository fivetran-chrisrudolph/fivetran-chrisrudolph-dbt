# repeated table assessment

Assessment run against `chris_rudolph_gcs_mdls` landed schemas matching `zzz_*_dbo`.

## Current environment shape

- schemas detected: 70
- repeated tables detected: 350

## Coverage distribution

- 340 tables present in all 70 schemas
- 10 tables present in 69 schemas

## Lower coverage tables

- ft_table_0100
- ft_table_0106
- ft_table_0202
- ft_table_0214
- ft_table_0220
- ft_table_0226
- ft_table_0322
- ft_table_0334
- ft_table_0340
- ft_table_0346

## Recommendation

Bulk scaffold the combined-table pattern for all 350 repeated tables. Treat the 10 lower-coverage tables as in-flight catch-up tables, not structural drift exceptions.
