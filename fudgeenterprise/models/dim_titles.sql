with stg_titles as (
    select * from {{ source('fudgeflix','ff_titles')}}
)
select  {{ dbt_utils.generate_surrogate_key(['stg_titles.title_id']) }} as titlekey, 
    stg_titles.* 
from stg_titles
