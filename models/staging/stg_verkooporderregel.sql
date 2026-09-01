with source as (

    select * from {{ source('raw', 'verkooporderregel') }}

),

renamed as (

    select
        verkooporderregel_id,
        verkooporder_id,
        klantartikel_id,
        cast(aantal as int)                as aantal,
        cast(prijs_per_eenheid as decimal(12, 2))    as prijs_per_eenheid,
        cast(regel_omzet as decimal(12, 2))          as regel_omzet,
        cast(meters as decimal(12, 2))               as meters,
        cast(vellen as int)                as vellen
    from source

)

select * from renamed
