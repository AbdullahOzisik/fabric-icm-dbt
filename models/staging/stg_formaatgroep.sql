with source as (

    select * from {{ source('raw', 'formaatgroep') }}

),

renamed as (

    select
        formaatgroep_id,
        formaatgroep_naam
    from source

)

select * from renamed
