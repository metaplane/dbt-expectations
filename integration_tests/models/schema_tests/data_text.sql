{% if target.type == 'teradata' %}
{# Teradata requires FROM clause for literal selects #}
select
    'ab@gmail.com' as email_address,
    '91001' as postal_code_5,
    '91001-123' as postal_code_5_3
    from SYS_CALENDAR.CALENDAR where day_of_calendar = 1


union all

select
    'ab@mail.com' as email_address,
    '90210' as postal_code_5,
    '90210-123' as postal_code_5_3
    from SYS_CALENDAR.CALENDAR where day_of_calendar = 1


union all

select
    'abc@gmail.com' as email_address,
    '90026' as postal_code_5,
    '90026-123' as postal_code_5_3
    from SYS_CALENDAR.CALENDAR where day_of_calendar = 1


union all

select
    'abc.com@gmail.com' as email_address,
    '09876' as postal_code_5,
    '09876-023' as postal_code_5_3
    from SYS_CALENDAR.CALENDAR where day_of_calendar = 1
{% else %}
{# Other adapters support literal selects without FROM clause #}
select
    'ab@gmail.com' as email_address,
    '91001' as postal_code_5,
    '91001-123' as postal_code_5_3

union all

select
    'ab@mail.com' as email_address,
    '90210' as postal_code_5,
    '90210-123' as postal_code_5_3

union all

select
    'abc@gmail.com' as email_address,
    '90026' as postal_code_5,
    '90026-123' as postal_code_5_3

union all

select
    'abc.com@gmail.com' as email_address,
    '09876' as postal_code_5,
    '09876-023' as postal_code_5_3
{% endif %}

