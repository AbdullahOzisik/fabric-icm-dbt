with source as (

    select * from {{ source('raw', 'd_datum') }}

),

renamed as (

    select
        cast(datum as date)    as datum,
        jaar,
        kwartaal,
        maand_nummer,
        maand_naam,
        jaar_maand,
        week_nummer,
        dag_van_week
    from source

)

select * from renamed
