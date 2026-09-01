with source as (

    select * from {{ source('raw', 'bewerkingscenario') }}

),

renamed as (

    select
        bewerkingscenario_id,
        bewerkingscenariogroep_id,
        scenario_naam
    from source

)

select * from renamed
