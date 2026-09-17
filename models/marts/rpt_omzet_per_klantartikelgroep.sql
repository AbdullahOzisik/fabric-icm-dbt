with order_lines as (

    select * from {{ ref('stg_verkooporderregel') }}

),

orders as (

    select * from {{ ref('stg_verkooporder') }}

),

klanten as (

    select * from {{ ref('stg_klant') }}

),

klantartikelen as (

    select * from {{ ref('stg_klantartikel') }}

),

artikelgroepen as (

    select * from {{ ref('stg_klantartikelgroep') }}

),

joined as (

    select
        orders.klant_id,
        klanten.klant_naam,
        artikelgroepen.klantartikelgroep_id,
        artikelgroepen.groep_naam,
        datepart(year, orders.order_datum)    as jaar,
        order_lines.regel_omzet,
        order_lines.aantal
    from order_lines
    inner join orders
        on order_lines.verkooporder_id = orders.verkooporder_id
    inner join klanten
        on orders.klant_id = klanten.klant_id
    inner join klantartikelen
        on order_lines.klantartikel_id = klantartikelen.klantartikel_id
    inner join artikelgroepen
        on klantartikelen.klantartikelgroep_id = artikelgroepen.klantartikelgroep_id

)

select
    klant_id,
    klant_naam,
    klantartikelgroep_id,
    groep_naam,
    jaar,
    sum(regel_omzet)    as totale_omzet,
    sum(aantal)          as totaal_aantal
from joined
group by klant_id, klant_naam, klantartikelgroep_id, groep_naam, jaar
order by jaar, totale_omzet desc
