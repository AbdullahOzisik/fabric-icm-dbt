with source as (

    select * from {{ source('raw', 'budget_intake') }}

),

renamed as (

    select
        klant_id,
        budgetbucket_id,
        jaar,
        cast(budget_omzet as decimal(12, 2))            as budget_omzet,
        cast(latest_estimate_omzet as decimal(12, 2))   as latest_estimate_omzet
    from source

)

select * from renamed
