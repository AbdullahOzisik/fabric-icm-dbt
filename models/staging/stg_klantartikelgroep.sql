with source as (

    select * from {{ source('raw', 'klantartikelgroep') }}

),

renamed as (

    select
        klantartikelgroep_id,
        groep_naam
    from source

)

select * from renamed
