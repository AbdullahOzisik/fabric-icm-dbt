with orders as (

    select * from {{ ref('stg_verkooporder') }}

),

order_lines as (

    select * from {{ ref('stg_verkooporderregel') }}

),

klanten as (

    select * from {{ ref('stg_klant') }}

),

vestigingen as (

    select * from {{ ref('stg_vestiging') }}

),

joined as (

    select
        orders.klant_id,
        klanten.klant_naam,
        vestigingen.vestiging_id,
        vestigingen.vestiging_naam,
        vestigingen.land,
        datepart(year, orders.order_datum)    as jaar,
        order_lines.regel_omzet
    from order_lines
    inner join orders
        on order_lines.verkooporder_id = orders.verkooporder_id
    inner join klanten
        on orders.klant_id = klanten.klant_id
    inner join vestigingen
        on orders.vestiging_id = vestigingen.vestiging_id

)

select
    klant_id,
    klant_naam,
    vestiging_id,
    vestiging_naam,
    land,
    jaar,
    sum(regel_omzet)    as totale_omzet
from joined
group by klant_id, klant_naam, vestiging_id, vestiging_naam, land, jaar
order by jaar, totale_omzet desc
