with source as (

    select * from {{ source('raw', 'vestiging') }}

),

renamed as (

    select
        vestiging_id,
        vestiging_naam,
        land
    from source

)

select * from renamed
