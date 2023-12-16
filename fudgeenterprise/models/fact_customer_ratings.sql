with
    stg_accounts as (
        select
            {{ dbt_utils.generate_surrogate_key(["account_id"]) }} as accountkey,
            account_id
        from {{ source("fudgeflix", "ff_accounts") }}
    ),

    stg_titles as (
        select
            {{ dbt_utils.generate_surrogate_key(["title_id"]) }} as titlekey,
            title_id,
            title_name as titlename,
            title_type as titletype,
            title_avg_rating as titleavgrating
        from {{ source("fudgeflix", "ff_titles") }}
    ),

    stg_account_titles as (
        select *, at_rating as rating
        from {{ source("fudgeflix", "ff_account_titles") }}
    ),

    stg_title_genres as (
        select tg_genre_name as genrename, tg_title_id
        from {{ source("fudgeflix", "ff_title_genres") }}
    )

select
    sa.accountkey,
    st.titlekey,
    sat.rating,
    st.titlename,
    st.titletype,
    st.titleavgrating,
    stg.genrename
from stg_account_titles sat
join stg_accounts sa on sat.at_account_id = sa.account_id
join stg_titles st on sat.at_title_id = st.title_id
join stg_title_genres stg on st.title_id = stg.tg_title_id
