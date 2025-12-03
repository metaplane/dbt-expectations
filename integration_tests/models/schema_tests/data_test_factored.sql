{% if target.type == 'teradata' %}
{# Teradata requires explicit column list when combining SELECT * with additional columns #}
select
    sb1.idx,
    sb1.date_col,
    sb1.col_numeric_a,
    sb1.col_numeric_b,
    sb1.col_string_a,
    sb1.col_string_b,
    sb1.col_null,
    sb1.col_null_2,
    sb1.col_numeric_a_plus_b,
    sb1.idx_multiplied_by_2,
    sb1.idx_multiplied_by_minus_2,
    1 as factor
from
    {{ ref("data_test") }} as sb1

union all

select
    sb.idx,
    sb.date_col,
    sb.col_numeric_a,
    sb.col_numeric_b,
    sb.col_string_a,
    sb.col_string_b,
    sb.col_null,
    sb.col_null_2,
    sb.col_numeric_a_plus_b,
    sb.idx_multiplied_by_2,
    sb.idx_multiplied_by_minus_2,
    2 as factor
from
    {{ ref("data_test") }} as sb
{% else %}
{# Other adapters support SELECT * with additional columns #}
select
    1 as factor,
    *
from
    {{ ref("data_test") }}

union all

select
    2 as factor,
    *
from
    {{ ref("data_test") }}
{% endif %}
