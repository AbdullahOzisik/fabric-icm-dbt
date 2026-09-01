with orders as (

    select * from {{ ref('stg_verkooporder') }}

),

order_lines as (

    select * from {{ ref('stg_verkooporderregel') }}

),

vestigingen as (

    select * from {{ ref('stg_vestiging') }}

),

joined as (

    select
        vestigingen.vestiging_id,
        vestigingen.vestiging_naam,
        vestigingen.land,
        datepart(year, orders.order_datum)    as jaar,
        order_lines.regel_omzet
    from order_lines
    inner join orders
        on order_lines.verkooporder_id = orders.verkooporder_id
    inner join vestigingen
        on orders.vestiging_id = vestigingen.vestiging_id

)

select
    vestiging_id,
    vestiging_naam,
    land,
    jaar,
    sum(regel_omzet)    as totale_omzet
from joined
group by vestiging_id, vestiging_naam, land, jaar
order by jaar, totale_omzet desc
