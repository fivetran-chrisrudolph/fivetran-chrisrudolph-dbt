{#
    -- grant_select:
    1. grants SELECT on all tables and views in a schema
    2. defaults to the current target's database/schema
    3. defaults to granting to the connection's current Snowflake role when target.role
       isn't set (e.g. SSO/OAuth connections don't populate target.role)
#}

{% macro grant_select(database=target.database, schema=target.schema, role=target.role) %}

    {% if role is none %}
        {% set role = run_query('select current_role()').columns[0].values()[0] %}
    {% endif %}

    {% set sql %}
        grant select on all tables in schema {{ database }}.{{ schema }} to role {{ role }};
        grant select on all views in schema {{ database }}.{{ schema }} to role {{ role }};
    {% endset %}

    {{ log('Granting select on ' ~ database ~ '.' ~ schema ~ ' to role ' ~ role, info=True) }}
    {% do run_query(sql) %}
    {{ log('Grant complete.', info=True) }}

{% endmacro %}

