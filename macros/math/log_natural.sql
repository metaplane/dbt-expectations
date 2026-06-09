{% macro log_natural(x) -%}
    {{ adapter.dispatch('log_natural', 'dbt_expectations') (x) }}
{%- endmacro %}

{% macro default__log_natural(x) -%}

    ln({{ x }})

{%- endmacro -%}

{% macro bigquery__log_natural(x) -%}

    ln({{ x }})

{%- endmacro -%}

{% macro snowflake__log_natural(x) -%}

    ln({{ x }})

{%- endmacro -%}

{% macro spark__log_natural(x) -%}

    ln({{ x }})

{%- endmacro -%}

{% macro sqlserver__log_natural(x) -%}

    log({{ x }})

{%- endmacro -%}
