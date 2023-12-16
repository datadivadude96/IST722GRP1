with stg_customers as (
    select * from {{ source('fudgemart','fm_customers')}}
)
select  {{ dbt_utils.generate_surrogate_key(['stg_customers.customer_id']) }} as customerkey, 
    stg_customers.* 
from stg_customers

