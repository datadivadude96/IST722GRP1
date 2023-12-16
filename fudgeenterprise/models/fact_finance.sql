with
    stg_plans as (select * from {{ source("fudgeflix", "ff_plans") }}),

    d_combined_customers as (select * from {{ ref("dim_combined_customers") }}),

    stg_account_details as (
        select
            {{ dbt_utils.generate_surrogate_key(["ab_account_id"]) }} as accountkey,
            {{ dbt_utils.generate_surrogate_key(["ab_plan_id"]) }} as plankey,
            ab.*
        from fudgeflix.ff_account_billing ab
    ),

    stg_product as (select * from {{ source("fudgemart", "fm_products") }}),

    stg_orders_details as (
        select
            {{ dbt_utils.generate_surrogate_key(["order_id"]) }} as orderkey,
            {{ dbt_utils.generate_surrogate_key(["product_id"]) }} as productkey,
            fm_order_details.*
        from {{ source("fudgemart", "fm_order_details") }} fm_order_details
    ),

    stg_orders as (
        select
            {{ dbt_utils.generate_surrogate_key(["order_id"]) }} as orderkey,
            {{ dbt_utils.generate_surrogate_key(["customer_id"]) }} as customerkey,
            replace(to_date(order_date)::varchar, '-', '')::int as orderdatekey,
            *
        from {{ source("fudgemart", "fm_orders") }}
    )

-- Modified Query
select
    'Account Details' as source,
    ab.accountkey,
    ab.plankey,
    ab.ab_billed_amount as totalbilledamount,
    null as orderkey,
    dcc.customerkey as order_customerkey,
    null as orderdatekey,
    null as productkey,
    null as quantity,
    null as soldamount
from stg_account_details ab
join stg_plans p on p.plan_id = ab.ab_plan_id
join d_combined_customers dcc on ab.accountkey = dcc.customerkey  -- Join with dim_combined_customers

union all

select
    'Orders' as source,
    null as accountkey,
    null as plankey,
    null as totalbilledamount,
    od.orderkey,
    dcc.customerkey as order_customerkey,
    o.orderdatekey,
    od.productkey,
    od.order_qty as quantity,
    od.order_qty * p.product_retail_price as soldamount
from stg_orders_details od
join stg_product p on od.product_id = p.product_id
join stg_orders o on o.order_id = od.order_id
join d_combined_customers dcc on o.customerkey = dcc.customerkey  -- Join with dim_combined_customers
order by source
