{% test expression_is_true(model,
                                 expression,
                                 test_condition="= true",
                                 group_by_columns=None,
                                 row_condition=None
                                 ) %}

    {{ dbt_expectations.expression_is_true(model, expression, test_condition, group_by_columns, row_condition) }}

{% endtest %}

{% macro expression_is_true(model,
                                 expression,
                                 test_condition="= true",
                                 group_by_columns=None,
                                 row_condition=None
                                 ) %}
    {{ adapter.dispatch('expression_is_true', 'dbt_expectations') (model, expression, test_condition, group_by_columns, row_condition) }}
{%- endmacro %}

{% macro default__expression_is_true(model, expression, test_condition, group_by_columns, row_condition) -%}
with grouped_expression as (
    select
        {% if group_by_columns %}
        {% for group_by_column in group_by_columns -%}
        {{ group_by_column }} as col_{{ loop.index }},
        {% endfor -%}
        {% endif %}
        {{ dbt_expectations.truth_expression(expression) }}
    from {{ model }}
     {%- if row_condition %}
    where
        {{ row_condition }}
    {% endif %}
    {% if group_by_columns %}
    group by
    {% for group_by_column in group_by_columns -%}
        {{ group_by_column }}{% if not loop.last %},{% endif %}
    {% endfor %}
    {% endif %}

),
validation_errors as (

    select
        *
    from
        grouped_expression
    where
        not(expression {{ test_condition }})

)

select *
from validation_errors


{% endmacro -%}

{# Teradata override: Teradata does not support bare boolean expressions in the select list.
   We rewrite the truth expression as a CASE producing 1/0 and normalize test_condition.
   Also Teradata lacks a native boolean type, so comparisons must be numeric. #}
{% macro teradata__expression_is_true(model, expression, test_condition, group_by_columns, row_condition) -%}
    {# Normalize test condition '= true' -> '= 1' and '!= true' -> '!= 1' etc. #}
    {% set normalized = test_condition %}
    {% if normalized is string %}
        {% if normalized|lower == '= true' %}
            {% set normalized = '= 1' %}
        {% elif normalized|lower == '!= true' %}
            {% set normalized = '!= 1' %}
        {% elif normalized|lower == '= false' %}
            {% set normalized = '= 0' %}
        {% elif normalized|lower == '!= false' %}
            {% set normalized = '!= 0' %}
        {% endif %}
    {% endif %}
with grouped_expression as (
    select
        {% if group_by_columns %}
        {% for group_by_column in group_by_columns -%}
        {{ group_by_column }} as col_{{ loop.index }},
        {% endfor -%}
        {% endif %}
        case when ({{ expression }}) then 1 else 0 end as expression
    from {{ model }}
    {%- if row_condition %}
    where
        {{ row_condition }}
    {% endif %}
    {% if group_by_columns %}
    group by
    {% for group_by_column in group_by_columns -%}
        {{ group_by_column }}{% if not loop.last %},{% endif %}
    {% endfor %}
    {% endif %}
),
validation_errors as (
    select *
    from grouped_expression
    where not(expression {{ normalized }})
)
select *
from validation_errors
{% endmacro -%}
