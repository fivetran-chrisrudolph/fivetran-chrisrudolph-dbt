with orders as (
    select * from {{ ref('stg_jaffle_shop__orders') }}
),

payments as (
    select * from {{ ref('stg_stripe__payments') }}
),

order_payments as (
    select
        order_id,
        sum(amount) as amount
    from payments
    group by order_id
),

final as (
    select
        orders.order_id,
        orders.customer_id,
        order_payments.amount
    from orders
    left join order_payments using (order_id)
)

select * from final