{% if target.type == 'teradata' %}
{# Teradata requires explicit CAST and FROM clause for literal selects #}
with data_example as (

    select
        1 as idx,
        '2020-10-21' as date_col,
        cast(0 as {{ dbt.type_float() }}) as col_numeric_a
    
    from SYS_CALENDAR.CALENDAR where day_of_calendar = 1

    union all

    select
        2 as idx,
        '2020-10-22' as date_col,
        1 as col_numeric_a

    from SYS_CALENDAR.CALENDAR where day_of_calendar = 1

    union all

    select
        2 as idx,
        '2020-10-23' as date_col,
        2 as col_numeric_a

    from SYS_CALENDAR.CALENDAR where day_of_calendar = 1

    union all

    select
        2 as idx,
        '2020-10-24' as date_col,
        1 as col_numeric_a

    from SYS_CALENDAR.CALENDAR where day_of_calendar = 1

    union all

    select
        3 as idx,
        '2020-10-23' as date_col,
        0.5 as col_numeric_a

        from SYS_CALENDAR.CALENDAR where day_of_calendar = 1

    union all

    select
        4 as idx,
        '2020-10-23' as date_col,
        0.5 as col_numeric_a
    
    from SYS_CALENDAR.CALENDAR where day_of_calendar = 1
    
)
select
    data_example.*,
    sum(col_numeric_a) over (partition by idx order by date_col rows between unbounded preceding and current row) as rolling_sum_increasing,
    sum(col_numeric_a) over (partition by idx order by date_col desc rows between unbounded preceding and current row) as rolling_sum_decreasing
from
    data_example
{% else %}
{# Other adapters support simpler literal selects without FROM clause #}
with data_example as (

    select
        1 as idx,
        '2020-10-21' as date_col,
        cast(0 as {{ dbt.type_float() }}) as col_numeric_a

    union all

    select
        2 as idx,
        '2020-10-22' as date_col,
        1 as col_numeric_a

    union all

    select
        2 as idx,
        '2020-10-23' as date_col,
        2 as col_numeric_a

    union all

    select
        2 as idx,
        '2020-10-24' as date_col,
        1 as col_numeric_a

    union all

    select
        3 as idx,
        '2020-10-23' as date_col,
        0.5 as col_numeric_a

    union all

    select
        4 as idx,
        '2020-10-23' as date_col,
        0.5 as col_numeric_a

)
select
    *,
    sum(col_numeric_a) over (partition by idx order by date_col) as rolling_sum_increasing,
    sum(col_numeric_a) over (partition by idx order by date_col desc) as rolling_sum_decreasing
from
    data_example
{% endif %}
