with vehicles as (

    select * from {{ ref('stg_rdw__vehicles') }}

),

aggregated as (

    select
        brand,
        vehicle_type,
        count(*)                                  as vehicle_count,
        avg(catalog_price_eur)                    as avg_catalog_price_eur,
        min(first_admission_date)                 as earliest_first_admission_date,
        max(first_admission_date)                 as latest_first_admission_date
    from vehicles
    group by brand, vehicle_type

)

select * from aggregated
