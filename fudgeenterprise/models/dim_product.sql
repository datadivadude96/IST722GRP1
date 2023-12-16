with stg_product as (
    select * from {{source('fudgemart','fm_products')}}
)

select  {{ dbt_utils.generate_surrogate_key(['stg_product.product_id']) }} as productkey, 
    stg_product.* 
from stg_product
