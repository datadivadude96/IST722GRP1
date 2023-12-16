with
    f_customer_ratings as (select * from {{ ref("fact_customer_ratings") }}),
    d_accounts as (select * from {{ ref("dim_accounts") }}),
    d_titles as (select * from {{ ref("dim_titles") }})

select d_accounts.*, d_titles.*, f.rating, f.genrename
from f_customer_ratings as f
left join d_accounts on f.accountkey = d_accounts.accountkey
left join d_titles on f.titlekey = d_titles.titlekey
