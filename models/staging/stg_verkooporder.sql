with source as (

    select * from {{ source('raw', 'verkooporder') }}

),

renamed as (

    select
        verkooporder_id,
        order_nummer,
        klant_id,
        medewerker_id,
        vestiging_id,
        cast(order_datum as date)    as order_datum,
        status
    from source

)

select * from renamed
