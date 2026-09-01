with orders as (

    select * from {{ ref('stg_verkooporder') }}

),

order_lines as (

    select * from {{ ref('stg_verkooporderregel') }}

),

klanten as (

    select * from {{ ref('stg_klant') }}

),

concerns as (

    select * from {{ ref('stg_concern') }}

),

vestigingen as (

    select * from {{ ref('stg_vestiging') }}

),

medewerkers as (

    select * from {{ ref('stg_medewerker') }}

),

omzet_per_klant as (

    select
        orders.klant_id,
        sum(order_lines.regel_omzet)              as totale_omzet,
        count(distinct orders.verkooporder_id)     as aantal_orders
    from order_lines
    inner join orders
        on order_lines.verkooporder_id = orders.verkooporder_id
    group by orders.klant_id

)

select
    klanten.klant_id,
    klanten.klant_naam,
    concerns.concern_naam,
    vestigingen.vestiging_naam,
    medewerkers.medewerker_naam    as accountmanager_naam,
    omzet_per_klant.totale_omzet,
    omzet_per_klant.aantal_orders,
    rank() over (order by omzet_per_klant.totale_omzet desc)    as omzet_rank
from omzet_per_klant
inner join klanten
    on omzet_per_klant.klant_id = klanten.klant_id
left join concerns
    on klanten.concern_id = concerns.concern_id
left join vestigingen
    on klanten.vestiging_id = vestigingen.vestiging_id
left join medewerkers
    on klanten.accountmanager_id = medewerkers.medewerker_id
order by omzet_per_klant.totale_omzet desc
