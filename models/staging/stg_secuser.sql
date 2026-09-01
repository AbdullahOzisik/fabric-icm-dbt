with source as (

    select * from {{ source('raw', 'secuser') }}

),

renamed as (

    select
        secuser_id,
        medewerker_id,
        gebruikersnaam,
        rol
    from source

)

select * from renamed
