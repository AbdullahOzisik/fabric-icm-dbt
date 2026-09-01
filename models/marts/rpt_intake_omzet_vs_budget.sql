with actual as (

    select * from {{ ref('int_actual_omzet_maand') }}

),

budget as (

    select
        budget_intake.klant_id,
        budget_intake.jaar,
        budgetbucket.maand_nummer,
        budgetbucket.maand_naam,
        budget_intake.budget_omzet,
        budget_intake.latest_estimate_omzet
    from {{ ref('stg_budget_intake') }} as budget_intake
    inner join {{ ref('stg_budgetbucket') }} as budgetbucket
        on budget_intake.budgetbucket_id = budgetbucket.budgetbucket_id

),

klanten as (

    select * from {{ ref('stg_klant') }}

),

combined as (

    select
        coalesce(actual.klant_id, budget.klant_id)            as klant_id,
        coalesce(actual.jaar, budget.jaar)                    as jaar,
        coalesce(actual.maand_nummer, budget.maand_nummer)    as maand_nummer,
        budget.maand_naam,
        coalesce(actual.actual_omzet, 0)                      as actual_omzet,
        coalesce(budget.budget_omzet, 0)                      as budget_omzet,
        coalesce(budget.latest_estimate_omzet, 0)             as latest_estimate_omzet
    from actual
    full outer join budget
        on actual.klant_id = budget.klant_id
        and actual.jaar = budget.jaar
        and actual.maand_nummer = budget.maand_nummer

)

select
    combined.klant_id,
    klanten.klant_naam,
    combined.jaar,
    combined.maand_nummer,
    combined.maand_naam,
    combined.actual_omzet,
    combined.budget_omzet,
    combined.latest_estimate_omzet,
    combined.actual_omzet - combined.budget_omzet    as afwijking_vs_budget
from combined
left join klanten
    on combined.klant_id = klanten.klant_id
