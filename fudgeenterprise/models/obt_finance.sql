with
    f_finance as (select * from {{ ref("fact_finance") }}),
    d_customer as (select * from {{ ref("dim_combined_customers") }}),
    d_date as (select * from {{ ref("dim_date") }}),
    d_product as (select * from {{ ref("dim_product") }}),
    d_account as (select * from {{ ref("dim_accounts") }}),
    d_plan as (select * from {{ ref("dim_plans") }})

select
    d_customer.*,
    d_date.*,
    d_product.*,
    d_account.*,
    d_plan.*,
    f.quantity,
    f.soldamount,
    f.totalbilledamount
from f_finance as f
left join d_customer on f.order_customerkey = d_customer.customerkey
left join d_date on f.orderdatekey = d_date.datekey
left join d_product on f.productkey = d_product.productkey
left join d_account on f.accountkey = d_account.accountkey
left join d_plan on f.plankey = d_plan.plankey
