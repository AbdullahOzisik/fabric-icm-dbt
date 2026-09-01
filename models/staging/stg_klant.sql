with source as (

    select * from {{ source('raw', 'klant') }}

),

renamed as (

    select
        klant_id,
        klant_nummer,
        klant_naam,
        concern_id,
        vestiging_id,
        accountmanager_id,
        actief    as is_actief
    from source

)

select * from renamed
