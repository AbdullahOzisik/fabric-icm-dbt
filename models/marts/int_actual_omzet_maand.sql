with orders as (

    select * from {{ ref('stg_verkooporder') }}

),

order_lines as (

    select * from {{ ref('stg_verkooporderregel') }}

),

joined as (

    select
        orders.klant_id,
        datepart(year, orders.order_datum)     as jaar,
        datepart(month, orders.order_datum)    as maand_nummer,
        order_lines.regel_omzet
    from order_lines
    inner join orders
        on order_lines.verkooporder_id = orders.verkooporder_id

),

aggregated as (

    select
        klant_id,
        jaar,
        maand_nummer,
        sum(regel_omzet)    as actual_omzet
    from joined
    group by klant_id, jaar, maand_nummer

)

select * from aggregated
