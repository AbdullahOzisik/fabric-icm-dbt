with source as (

    select * from {{ source('raw', 'etiket') }}

),

renamed as (

    select
        etiket_id,
        etiket_type
    from source

)

select * from renamed
