{% macro get_tenant_relations(table_name, database=var('raw_database'), tenant_seed_relation=ref(var('tenant_schema_seed_name'))) %}
    {% set tenant_query %}
        select tenant_id, source_server, source_database, source_schema
        from {{ tenant_seed_relation }}
        where enabled = true
        order by tenant_id
    {% endset %}

    {% if execute %}
        {% set tenant_rows = run_query(tenant_query) %}
    {% else %}
        {% set tenant_rows = none %}
    {% endif %}

    {% set relations = [] %}

    {% if execute and tenant_rows is not none %}
        {% for row in tenant_rows %}
            {% set tenant_id = row[0] %}
            {% set source_server = row[1] %}
            {% set source_database = row[2] %}
            {% set source_schema = row[3] %}
            {% set relation = adapter.get_relation(database=database, schema=source_schema, identifier=table_name) %}

            {% if relation is not none %}
                {% do relations.append({
                    'tenant_id': tenant_id,
                    'source_server': source_server,
                    'source_database': source_database,
                    'source_schema': source_schema,
                    'relation': relation
                }) %}
            {% endif %}
        {% endfor %}
    {% endif %}

    {{ return(relations) }}
{% endmacro %}
