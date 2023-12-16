with
    stg_customer_product_review as (
        select
            {{ dbt_utils.generate_surrogate_key(["customer_id"]) }} as customerkey,
            {{ dbt_utils.generate_surrogate_key(["product_id"]) }} as productkey,
            *
        from {{ source("fudgemart", "fm_customer_product_reviews") }}
    ),
    stg_customer as (select * from {{ source("fudgemart", "fm_customers") }}),

    stg_customer_survey as (
        select * from {{ source("fudgemart", "fudgemart_customer_survey") }}
    )

select
    cpr.customerkey,
    cpr.productkey,
    cpr.review_date,
    cs.email,
    cs.favorite_department,
    cpr.review_stars as totalreview
from stg_customer c
join stg_customer_product_review cpr on c.customer_id = cpr.customer_id
join stg_customer_survey cs on c.customer_email = cs.email
