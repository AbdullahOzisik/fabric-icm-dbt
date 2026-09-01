with source as (

    select * from {{ source('raw', 'klantartikel') }}

),

renamed as (

    select
        klantartikel_id,
        klant_id,
        klantartikelgroep_id,
        artikel_code,
        artikel_omschrijving,
        etiket_id,
        formaatgroep_id,
        droogtechniek_id,
        artikelpapier_id,
        tussensnee_id,
        bewerkingscenario_id
    from source

)

select * from renamed
