with
    stg_fudgemart_customers as (
        select * from {{ source("fudgemart", "fm_customers") }}
    ),
    fudgemart_data as (
        select
            {{ dbt_utils.generate_surrogate_key(["customer_id"]) }} as customerkey,
            customer_email as fudgemart_customer_email,  -- Rename for clarity
            'fudgemart' as source_system,
            stg_fudgemart_customers.*
        from stg_fudgemart_customers
    ),

    -- Fudgeflix accounts
    stg_fudgeflix_accounts as (
        select
        account_id,
        account_email,
        account_firstname as customer_firstname,
        account_lastname as customer_lastname,
        account_address as customer_address,
        account_zipcode as customer_zip,
        null as customer_city,  
        null as customer_state,  
        null as customer_phone,
        null as customer_fax 
    from fudgeflix.ff_accounts
    ),

    fudgeflix_data as (
        select
            {{ dbt_utils.generate_surrogate_key(["account_id"]) }} as customerkey,
            account_email as fudgeflix_account_email,  -- Rename for clarity
            'fudgeflix' as source_system,
            stg_fudgeflix_accounts.*
        from stg_fudgeflix_accounts
    ),

    -- Combined data with indicator for presence in both systems
    combined_data as (
        select
            fd.*,  -- Select all columns from fudgemart_data
            case
                when fd.fudgemart_customer_email in 
                     (select fudgeflix_account_email from fudgeflix_data)
                then 'Both'
                else source_system
            end as is_in_both
        from fudgemart_data fd
        left join
            (select distinct account_email as fudgeflix_account_email from fudgeflix_data) ff
            on fd.fudgemart_customer_email = ff.fudgeflix_account_email  -- Join with renamed fields
    )

select *
from combined_data

union all

select
    ff.*,  -- Select all columns from fudgeflix_data
    source_system as is_in_both  -- Fudgeflix customers are not in Fudgemart by default
from fudgeflix_data ff
