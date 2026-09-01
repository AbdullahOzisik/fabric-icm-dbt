-- Spark-vrij alternatief voor csv_to_delta.ipynb.
-- Draai dit in de Fabric SQL-query-editor van het Warehouse "dbt_raw"
-- (Landing_bron_data.Lakehouse/Files/<naam>.csv als bron, geen Spark nodig).
--
-- Pas <workspace> aan naar de echte workspace-naam/id uit je OneLake-pad
-- (in het pad dat je eerder deelde was dit "DEV").

declare @onelake_base varchar(500) = 'https://onelake.dfs.fabric.microsoft.com/DEV/Landing_bron_data.Lakehouse/Files';

create schema raw;
go

-- concern
create table raw.concern (
    concern_id int,
    concern_naam varchar(200)
);
go
copy into raw.concern
from 'https://onelake.dfs.fabric.microsoft.com/DEV/Landing_bron_data.Lakehouse/Files/concern.csv'
with (file_type = 'CSV', firstrow = 2, fieldterminator = ',');
go

-- vestiging
create table raw.vestiging (
    vestiging_id int,
    vestiging_naam varchar(200),
    land varchar(10)
);
go
copy into raw.vestiging
from 'https://onelake.dfs.fabric.microsoft.com/DEV/Landing_bron_data.Lakehouse/Files/vestiging.csv'
with (file_type = 'CSV', firstrow = 2, fieldterminator = ',');
go

-- medewerker
create table raw.medewerker (
    medewerker_id int,
    medewerker_naam varchar(200),
    functie varchar(100)
);
go
copy into raw.medewerker
from 'https://onelake.dfs.fabric.microsoft.com/DEV/Landing_bron_data.Lakehouse/Files/medewerker.csv'
with (file_type = 'CSV', firstrow = 2, fieldterminator = ',');
go

-- secuser
create table raw.secuser (
    secuser_id int,
    medewerker_id int,
    gebruikersnaam varchar(100),
    rol varchar(100)
);
go
copy into raw.secuser
from 'https://onelake.dfs.fabric.microsoft.com/DEV/Landing_bron_data.Lakehouse/Files/secuser.csv'
with (file_type = 'CSV', firstrow = 2, fieldterminator = ',');
go

-- klant
create table raw.klant (
    klant_id int,
    klant_nummer varchar(50),
    klant_naam varchar(200),
    concern_id int,
    vestiging_id int,
    accountmanager_id int,
    actief bit
);
go
copy into raw.klant
from 'https://onelake.dfs.fabric.microsoft.com/DEV/Landing_bron_data.Lakehouse/Files/klant.csv'
with (file_type = 'CSV', firstrow = 2, fieldterminator = ',');
go

-- klantartikelgroep
create table raw.klantartikelgroep (
    klantartikelgroep_id int,
    groep_naam varchar(200)
);
go
copy into raw.klantartikelgroep
from 'https://onelake.dfs.fabric.microsoft.com/DEV/Landing_bron_data.Lakehouse/Files/klantartikelgroep.csv'
with (file_type = 'CSV', firstrow = 2, fieldterminator = ',');
go

-- etiket
create table raw.etiket (
    etiket_id int,
    etiket_type varchar(100)
);
go
copy into raw.etiket
from 'https://onelake.dfs.fabric.microsoft.com/DEV/Landing_bron_data.Lakehouse/Files/etiket.csv'
with (file_type = 'CSV', firstrow = 2, fieldterminator = ',');
go

-- formaatgroep
create table raw.formaatgroep (
    formaatgroep_id int,
    formaatgroep_naam varchar(100)
);
go
copy into raw.formaatgroep
from 'https://onelake.dfs.fabric.microsoft.com/DEV/Landing_bron_data.Lakehouse/Files/formaatgroep.csv'
with (file_type = 'CSV', firstrow = 2, fieldterminator = ',');
go

-- droogtechniek
create table raw.droogtechniek (
    droogtechniek_id int,
    droogtechniek_naam varchar(100)
);
go
copy into raw.droogtechniek
from 'https://onelake.dfs.fabric.microsoft.com/DEV/Landing_bron_data.Lakehouse/Files/droogtechniek.csv'
with (file_type = 'CSV', firstrow = 2, fieldterminator = ',');
go

-- artikelpapier (al als Delta-tabel geladen, maar ook hier voor het geval je alles via COPY INTO wil doen)
create table raw.artikelpapier (
    artikelpapier_id int,
    papier_type varchar(100)
);
go
copy into raw.artikelpapier
from 'https://onelake.dfs.fabric.microsoft.com/DEV/Landing_bron_data.Lakehouse/Files/artikelpapier.csv'
with (file_type = 'CSV', firstrow = 2, fieldterminator = ',');
go

-- tussensnee
create table raw.tussensnee (
    tussensnee_id int,
    tussensnee_naam varchar(100)
);
go
copy into raw.tussensnee
from 'https://onelake.dfs.fabric.microsoft.com/DEV/Landing_bron_data.Lakehouse/Files/tussensnee.csv'
with (file_type = 'CSV', firstrow = 2, fieldterminator = ',');
go

-- bewerkingscenariogroep
create table raw.bewerkingscenariogroep (
    bewerkingscenariogroep_id int,
    groep_naam varchar(200)
);
go
copy into raw.bewerkingscenariogroep
from 'https://onelake.dfs.fabric.microsoft.com/DEV/Landing_bron_data.Lakehouse/Files/bewerkingscenariogroep.csv'
with (file_type = 'CSV', firstrow = 2, fieldterminator = ',');
go

-- bewerkingscenario (al als Delta-tabel geladen, ook hier voor de volledigheid)
create table raw.bewerkingscenario (
    bewerkingscenario_id int,
    bewerkingscenariogroep_id int,
    scenario_naam varchar(200)
);
go
copy into raw.bewerkingscenario
from 'https://onelake.dfs.fabric.microsoft.com/DEV/Landing_bron_data.Lakehouse/Files/bewerkingscenario.csv'
with (file_type = 'CSV', firstrow = 2, fieldterminator = ',');
go

-- klantartikel
create table raw.klantartikel (
    klantartikel_id int,
    klant_id int,
    klantartikelgroep_id int,
    artikel_code varchar(50),
    artikel_omschrijving varchar(300),
    etiket_id int,
    formaatgroep_id int,
    droogtechniek_id int,
    artikelpapier_id int,
    tussensnee_id int,
    bewerkingscenario_id int
);
go
copy into raw.klantartikel
from 'https://onelake.dfs.fabric.microsoft.com/DEV/Landing_bron_data.Lakehouse/Files/klantartikel.csv'
with (file_type = 'CSV', firstrow = 2, fieldterminator = ',');
go

-- budgetbucket (al als Delta-tabel geladen, ook hier voor de volledigheid)
create table raw.budgetbucket (
    budgetbucket_id int,
    maand_nummer int,
    maand_naam varchar(20)
);
go
copy into raw.budgetbucket
from 'https://onelake.dfs.fabric.microsoft.com/DEV/Landing_bron_data.Lakehouse/Files/budgetbucket.csv'
with (file_type = 'CSV', firstrow = 2, fieldterminator = ',');
go

-- d_datum
create table raw.d_datum (
    datum date,
    jaar int,
    kwartaal varchar(5),
    maand_nummer int,
    maand_naam varchar(20),
    jaar_maand varchar(10),
    week_nummer int,
    dag_van_week varchar(20)
);
go
copy into raw.d_datum
from 'https://onelake.dfs.fabric.microsoft.com/DEV/Landing_bron_data.Lakehouse/Files/d_datum.csv'
with (file_type = 'CSV', firstrow = 2, fieldterminator = ',');
go

-- verkooporder
create table raw.verkooporder (
    verkooporder_id int,
    order_nummer varchar(50),
    klant_id int,
    medewerker_id int,
    vestiging_id int,
    order_datum date,
    status varchar(50)
);
go
copy into raw.verkooporder
from 'https://onelake.dfs.fabric.microsoft.com/DEV/Landing_bron_data.Lakehouse/Files/verkooporder.csv'
with (file_type = 'CSV', firstrow = 2, fieldterminator = ',');
go

-- verkooporderregel
create table raw.verkooporderregel (
    verkooporderregel_id int,
    verkooporder_id int,
    klantartikel_id int,
    aantal int,
    prijs_per_eenheid decimal(12, 2),
    regel_omzet decimal(12, 2),
    meters decimal(12, 2),
    vellen int
);
go
copy into raw.verkooporderregel
from 'https://onelake.dfs.fabric.microsoft.com/DEV/Landing_bron_data.Lakehouse/Files/verkooporderregel.csv'
with (file_type = 'CSV', firstrow = 2, fieldterminator = ',');
go

-- budget_intake (al als Delta-tabel geladen, ook hier voor de volledigheid)
create table raw.budget_intake (
    klant_id int,
    budgetbucket_id int,
    jaar int,
    budget_omzet decimal(12, 2),
    latest_estimate_omzet decimal(12, 2)
);
go
copy into raw.budget_intake
from 'https://onelake.dfs.fabric.microsoft.com/DEV/Landing_bron_data.Lakehouse/Files/budget_intake.csv'
with (file_type = 'CSV', firstrow = 2, fieldterminator = ',');
go
