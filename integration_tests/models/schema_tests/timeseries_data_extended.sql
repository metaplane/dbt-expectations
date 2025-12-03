with dates as (
    select * from {{ ref('timeseries_base') }}
),
row_values as (
    select * from {{ ref('series_10') }}
),
add_row_values as (

    select
        {% if target.type == 'teradata' %}
        
        cast(dates.date_day as date) as date_day,
        cast(row_values.generated_number as {{ dbt.type_float() }}) as row_value
        {% else %}
       
        cast(dates.date_day as {{ dbt_expectations.type_datetime() }}) as date_day,
        cast(100 * abs({{ dbt_expectations.rand() }}) as {{ dbt.type_float() }}) as row_value
        {% endif %}

    from
        dates
        cross join row_values

),
add_logs as (

    select
        {% if target.type == 'teradata' %}
        {# Teradata: Explicit column list to avoid SELECT * issues #}
        add_row_values.*,
        {% else %}
        {# Other adapters: SELECT * works fine #}
        *,
        {% endif %}
        {{ dbt_expectations.log_natural('nullif(row_value, 0)') }} as row_value_log
    from
        add_row_values
)
select *
from
    add_logs
