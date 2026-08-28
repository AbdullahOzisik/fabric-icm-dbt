with source as (

    select * from {{ source('rdw', 'rdw_data') }}

),

renamed as (

    select
        __id                                                        as vehicle_source_id,
        kenteken                                                     as license_plate,
        merk                                                         as brand,
        handelsbenaming                                              as trade_name,
        voertuigsoort                                                as vehicle_type,
        europese_voertuigcategorie                                   as eu_vehicle_category,
        inrichting                                                   as body_type,
        eerste_kleur                                                 as primary_color,
        tweede_kleur                                                 as secondary_color,

        cast(cilinderinhoud as decimal(10, 2))                       as cylinder_capacity_cc,
        cast(aantal_cilinders as int)                                as cylinder_count,
        cast(aantal_zitplaatsen as int)                              as seat_count,
        cast(aantal_deuren as int)                                   as door_count,
        cast(massa_ledig_voertuig as decimal(10, 2))                 as empty_weight_kg,
        cast(massa_rijklaar as decimal(10, 2))                       as ready_to_drive_weight_kg,
        cast(toegestane_maximum_massa_voertuig as decimal(10, 2))    as max_permitted_weight_kg,
        cast(catalogusprijs as decimal(12, 2))                       as catalog_price_eur,
        cast(bruto_bpm as decimal(12, 2))                            as gross_bpm_eur,

        cast(datum_eerste_toelating_dt as date)                      as first_admission_date,
        cast(datum_eerste_tenaamstelling_in_nederland_dt as date)    as first_registration_nl_date,
        cast(datum_tenaamstelling_dt as date)                        as registration_date,
        cast(vervaldatum_apk_dt as date)                             as apk_expiry_date,

        wam_verzekerd                                                as is_wam_insured,
        export_indicator                                             as is_exported

    from source

)

select * from renamed
