with source as (

    select * from {{ source('raw', 'tussensnee') }}

),

renamed as (

    select
        tussensnee_id,
        tussensnee_naam
    from source

)

select * from renamed
