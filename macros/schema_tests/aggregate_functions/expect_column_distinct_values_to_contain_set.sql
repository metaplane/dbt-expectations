{% test expect_column_distinct_values_to_contain_set(model, column_name,
                                                            value_set,
                                                            quote_values=True,
                                                            row_condition=None
                                                            ) %}

    {{ adapter.dispatch('test_expect_column_distinct_values_to_contain_set', 'dbt_expectations') (
            model, column_name, value_set, quote_values, row_condition
        ) }}

{% endtest %}

{% macro default__test_expect_column_distinct_values_to_contain_set(model, column_name,
                                                                    value_set,
                                                                    quote_values,
                                                                    row_condition
                                                                    ) %}

with all_values as (

    select distinct
        {{ column_name }} as value_field

    from {{ model }}
    {% if row_condition %}
    where {{ row_condition }}
    {% endif %}

),
set_values as (

    {% for value in value_set -%}
    select
        {% if quote_values -%}
        '{{ value }}'
        {%- else -%}
        {{ value }}
        {%- endif %} as value_field
    {% if not loop.last %}union all{% endif %}
    {% endfor %}

),
unique_set_values as (

    select distinct value_field
    from
        set_values

),
validation_errors as (
    -- values in set that are not in the list of values from the model
    select
        s.value_field
    from
        unique_set_values s
        left join
        all_values v on s.value_field = v.value_field
    where
        v.value_field is null

)

select *
from validation_errors

{% endmacro %}

{% macro teradata__test_expect_column_distinct_values_to_contain_set(model, column_name,
                                                                     value_set,
                                                                     quote_values,
                                                                     row_condition
                                                                     ) %}

with all_values as (

    select distinct
        {{ column_name }} as value_field

    from {{ model }}
    {% if row_condition %}
    where {{ row_condition }}
    {% endif %}

),
set_values as (

    {% for value in value_set -%}
    select
        {% if quote_values -%}
        '{{ value }}'
        {%- else -%}
        {{ value }}
        {%- endif %} as value_field
    from SYS_CALENDAR.CALENDAR where day_of_calendar = 1
    {% if not loop.last %}union all{% endif %}
    {% endfor %}

),
unique_set_values as (

    select distinct value_field
    from
        set_values

),
validation_errors as (
    -- values in set that are not in the list of values from the model
    select
        s.value_field
    from
        unique_set_values s
        left join
        all_values v on s.value_field = v.value_field
    where
        v.value_field is null

)

select *
from validation_errors

{% endmacro %}
