{% macro generate_tenant_surrogate_key(columns) %}
    md5(
        concat(
            {% for column in columns %}
                coalesce(cast({{ column }} as {{ dbt.type_string() }}), '_dbt_null_')
                {% if not loop.last %}, '||', {% endif %}
            {% endfor %}
        )
    )
{% endmacro %}
