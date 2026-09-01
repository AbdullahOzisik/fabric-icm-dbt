with source as (

    select * from {{ source('raw', 'droogtechniek') }}

),

renamed as (

    select
        droogtechniek_id,
        droogtechniek_naam
    from source

)

select * from renamed
