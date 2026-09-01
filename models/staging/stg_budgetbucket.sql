with source as (

    select * from {{ source('raw', 'budgetbucket') }}

),

renamed as (

    select
        budgetbucket_id,
        maand_nummer,
        maand_naam
    from source

)

select * from renamed
