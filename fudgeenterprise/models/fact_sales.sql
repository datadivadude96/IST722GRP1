with
    stg_product as (select * from {{ source("fudgemart", "fm_products") }}),

    stg_orders_details as (
        select
            {{ dbt_utils.generate_surrogate_key(["order_id"]) }} as orderkey,
            {{ dbt_utils.generate_surrogate_key(["product_id"]) }} as productkey,
            *
        from {{ source("fudgemart", "fm_order_details") }}
    ),
    stg_orders as (
        select
            {{ dbt_utils.generate_surrogate_key(["order_id"]) }} as orderkey,
            {{ dbt_utils.generate_surrogate_key(["customer_id"]) }} as customerkey,
            replace(to_date(order_date)::varchar, '-', '')::int as orderdatekey,
            *
        from {{ source("fudgemart", "fm_orders") }}
    )

select
    od.orderkey,
    o.customerkey,
    o.orderdatekey,
    od.productkey,
    od.order_qty as quantity,
    od.order_qty * p.product_retail_price as soldamount
from stg_orders_details od
join stg_product p on od.product_id = p.product_id
join stg_orders o on o.order_id = od.order_id
