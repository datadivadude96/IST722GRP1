with
    f_product_review as (select * from {{ ref("fact_product_review") }}),
    d_customer as (select * from {{ ref("dim_customer") }}),
    d_date as (select * from {{ ref("dim_date") }}),
    d_product as (select * from {{ ref("dim_product") }})

select d_customer.*, d_date.*, d_product.*, f.email, f.totalreview,f.favorite_department
from f_product_review as f
left join d_customer on f.customerkey = d_customer.customerkey
left join d_date on f.review_date = d_date.datekey
left join d_product on f.productkey = d_product.productkey

