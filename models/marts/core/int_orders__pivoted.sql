{% set payment_methods = ["bank_transfer", "credit_card", "coupon", "gift_card"] %}

select
    order_id,
    {% for payment_method in payment_methods %}
    sum(case when payment_method = '{{ payment_method }}' then amount else 0 end) as {{ payment_method }}_amount,
    {% endfor %}
    sum(amount) as total_amount
from {{ ref('stg_stripe__payment') }}
group by 1
