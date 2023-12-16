with stg_plans as (
    select * from {{ source('fudgeflix','ff_plans')}}
)
select  {{ dbt_utils.generate_surrogate_key(['stg_plans.plan_id']) }} as plankey, 
    stg_plans.* 
from stg_plans
