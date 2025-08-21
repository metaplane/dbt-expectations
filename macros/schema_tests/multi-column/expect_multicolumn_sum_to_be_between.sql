
{% test expect_multicolumn_sum_to_be_between(model,
                                                column_list,
                                                min_value=None,
                                                max_value=None,
                                                group_by=None,
                                                row_condition=None,
                                                strictly=False
                                                ) %}

{% set expression %}
{% for column in column_list %}
sum({{ column }}){% if not loop.last %} + {% endif %}
{# the if just allows for column names or literal numbers #}
{% endfor %}
{% endset %}

{%- if min_value is none and max_value is none -%}
{{ exceptions.raise_compiler_error(
    "You have to provide either a min_value, max_value or both."
) }}
{%- endif -%}

{%- set strict_operator = "" if strictly else "=" -%}

{% set expression_min_max %}
( 1=1
{%- if min_value is not none %} 
    and {{ expression | trim }} >{{ strict_operator }} 
    {% if min_value is number %}
        {{min_value}}
    {% else %}
        sum({{ min_value }})
    {% endif %}
{% endif %}

{%- if max_value is not none %} 
    and {{ expression | trim }} <{{ strict_operator }} 
    {% if max_value is number %}
        {{max_value}}
    {% else %}
        sum({{ max_value }})
    {% endif %}
{% endif %}
)
{% endset %}

{{ dbt_expectations.expression_is_true(model,
                                        expression=expression_min_max,
                                        group_by_columns=group_by_columns,
                                        row_condition=row_condition)
                                        }}

{% endtest %}
