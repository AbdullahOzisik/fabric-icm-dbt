with source as (

    select * from {{ source('raw', 'concern') }}

),

renamed as (

    select
        concern_id,
        concern_naam
    from source

)

select * from renamed
