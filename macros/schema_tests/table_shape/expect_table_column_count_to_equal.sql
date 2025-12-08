{%- test expect_table_column_count_to_equal(model, value) -%}
    {{ adapter.dispatch('test_expect_table_column_count_to_equal', 'dbt_expectations') (model, value) }}
{%- endtest -%}

{%- macro default__test_expect_table_column_count_to_equal(model, value) -%}
{%- if execute -%}
{%- set number_actual_columns = (adapter.get_columns_in_relation(model) | length) -%}
with test_data as (

    select
        {{ number_actual_columns }} as number_actual_columns,
        {{ value }} as value

)
select *
from test_data
where
    number_actual_columns != value
{%- endif -%}
{%- endmacro -%}

{%- macro teradata__test_expect_table_column_count_to_equal(model, value) -%}
{%- if execute -%}
{%- set number_actual_columns = (adapter.get_columns_in_relation(model) | length) -%}
with test_data as (

    select
        {{ number_actual_columns }} as number_actual_columns,
        {{ value }} as expected_value

)
select *
from test_data
where
    number_actual_columns <> expected_value
{%- endif -%}
{%- endmacro -%}
