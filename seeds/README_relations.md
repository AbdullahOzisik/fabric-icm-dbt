# Sample data - Intake Omzet

Belangrijkste relaties

- klant.concern_id -> concern.concern_id
- klant.vestiging_id -> vestiging.vestiging_id
- klant.accountmanager_id -> medewerker.medewerker_id
- secuser.medewerker_id -> medewerker.medewerker_id
- klantartikel.klant_id -> klant.klant_id
- klantartikel.klantartikelgroep_id -> klantartikelgroep.klantartikelgroep_id
- klantartikel.etiket_id -> etiket.etiket_id
- klantartikel.formaatgroep_id -> formaatgroep.formaatgroep_id
- klantartikel.droogtechniek_id -> droogtechniek.droogtechniek_id
- klantartikel.artikelpapier_id -> artikelpapier.artikelpapier_id
- klantartikel.tussensnee_id -> tussensnee.tussensnee_id
- klantartikel.bewerkingscenario_id -> bewerkingscenario.bewerkingscenario_id
- bewerkingscenario.bewerkingscenariogroep_id -> bewerkingscenariogroep.bewerkingscenariogroep_id
- verkooporder.klant_id -> klant.klant_id
- verkooporder.medewerker_id -> medewerker.medewerker_id
- verkooporder.vestiging_id -> vestiging.vestiging_id
- verkooporderregel.verkooporder_id -> verkooporder.verkooporder_id
- verkooporderregel.klantartikel_id -> klantartikel.klantartikel_id
- budget_intake.klant_id -> klant.klant_id
- budget_intake.budgetbucket_id -> budgetbucket.budgetbucket_id

Doel:
Gebruik verkooporder + verkooporderregel voor actual intake omzet.
Gebruik budget_intake voor Budget en Latest Estimate.
Gebruik d_datum als datumdimensie.
