with source as (

    select * from {{ source('raw', 'medewerker') }}

),

renamed as (

    select
        medewerker_id,
        medewerker_naam,
        functie
    from source

)

select * from renamed
