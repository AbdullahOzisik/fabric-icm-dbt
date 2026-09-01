with source as (

    select * from {{ source('raw', 'bewerkingscenariogroep') }}

),

renamed as (

    select
        bewerkingscenariogroep_id,
        groep_naam
    from source

)

select * from renamed
