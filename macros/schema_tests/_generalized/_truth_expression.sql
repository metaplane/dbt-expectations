
{% macro truth_expression(expression) %}
    {{ adapter.dispatch('truth_expression', 'dbt_expectations') (expression) }}
{% endmacro %}

{% macro default__truth_expression(expression) %}
  {{ expression }} as expression
{% endmacro %}

{% macro sqlserver__truth_expression(expression) %}
  case when {{ expression }} then 1 else 0 end as expression
{% endmacro %}
