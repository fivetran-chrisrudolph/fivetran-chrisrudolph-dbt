{% macro union_tenant_table(table_name, database=var('raw_database'), tenant_seed_relation=ref(var('tenant_schema_seed_name'))) %}
    {% set tenant_relations = get_tenant_relations(
        table_name=table_name,
        database=database,
        tenant_seed_relation=tenant_seed_relation
    ) %}

    {% if tenant_relations | length == 0 %}
        select
            cast(null as {{ dbt.type_string() }}) as tenant_id,
            cast(null as {{ dbt.type_string() }}) as source_server,
            cast(null as {{ dbt.type_string() }}) as source_database,
            cast(null as {{ dbt.type_string() }}) as source_schema
        where false
    {% else %}
        {% set column_names = [] %}

        {% for relation_entry in tenant_relations %}
            {% set relation_columns = adapter.get_columns_in_relation(relation_entry['relation']) %}
            {% for column in relation_columns %}
                {% if column.name | lower not in column_names %}
                    {% do column_names.append(column.name | lower) %}
                {% endif %}
            {% endfor %}
        {% endfor %}

        {% for relation_entry in tenant_relations %}
            {% set relation = relation_entry['relation'] %}
            {% set relation_columns = adapter.get_columns_in_relation(relation) %}
            {% set relation_column_names = relation_columns | map(attribute='name') | map('lower') | list %}

            select
                '{{ relation_entry['tenant_id'] }}' as tenant_id,
                '{{ relation_entry['source_server'] }}' as source_server,
                '{{ relation_entry['source_database'] }}' as source_database,
                '{{ relation_entry['source_schema'] }}' as source_schema,
                {% for column_name in column_names %}
                    {% if column_name in relation_column_names %}
                        {{ adapter.quote(column_name) }}
                    {% else %}
                        cast(null as {{ dbt.type_string() }}) as {{ adapter.quote(column_name) }}
                    {% endif %}
                    {% if not loop.last %},{% endif %}
                {% endfor %}
            from {{ relation }}

            {% if not loop.last %}
                union all
            {% endif %}
        {% endfor %}
    {% endif %}
{% endmacro %}
