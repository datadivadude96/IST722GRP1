with stg_accounts as (
    select * from {{ source('fudgeflix','ff_accounts')}}
)
select  {{ dbt_utils.generate_surrogate_key(['stg_accounts.account_id']) }} as accountkey, 
    stg_accounts.* 
from stg_accounts
