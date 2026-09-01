with source as (

    select * from {{ source('raw', 'artikelpapier') }}

),

renamed as (

    select
        artikelpapier_id,
        papier_type
    from source

)

select * from renamed
