-- CREATE TABLE & LOAD nomenclature INSEE activité NAF
CREATE TABLE activite (
    code_5 VARCHAR,
    code_4 VARCHAR,
    code_3 VARCHAR,
    code_2 VARCHAR,
    code_1 VARCHAR,
    libelle_5 VARCHAR,
    libelle_4 VARCHAR,
    libelle_3 VARCHAR,
    libelle_2 VARCHAR,
    libelle_1 VARCHAR
);
COPY activite FROM './nomenclatures/activite.csv';

-- CREATE TABLE & LOAD nomenclature INSEE catégories juridiques
CREATE TABLE cj (
    code_3 VARCHAR,
    code_2 VARCHAR,
    code_1 VARCHAR,
    libelle_3 VARCHAR,
    libelle_2 VARCHAR,
    libelle_1 VARCHAR
);
COPY cj FROM './nomenclatures/cj.csv';

--
-- JOIN des unités légales et établissements sur variable pivot siren
-- Filtrage sur unités légales et établissements actifs, et secteurs d'acivité:
-- 62.01Z	Programmation informatique
-- 62.02A	Conseil en systèmes et logiciels informatiques
-- 62.02B	Tierce maintenance de systèmes et d'applications informatiques
-- export CSV
COPY (
    SELECT
        e.activitePrincipaleEtablissement AS codeape,
        activite.libelle_5 AS libelleape,
        CAST(u.categorieJuridiqueUnitelegale AS VARCHAR) AS categoriejuridique,
        cj.libelle_3 AS libellecategoriejuridique,
        e.codeCommuneEtablissement AS codecommune,
        e.libelleCommuneEtablissement AS libellecommune
    FROM
        './sirene/StockEtablissement_utf8.csv' AS e
    JOIN
        './sirene/StockUniteLegale_utf8.csv' AS u ON e.siren = u.siren
    JOIN
        activite ON e.activitePrincipaleEtablissement = activite.code_5
    JOIN
        cj ON CAST(u.categorieJuridiqueUnitelegale AS VARCHAR) = cj.code_3
    WHERE
        e.etatAdministratifEtablissement = 'A'
        AND u.etatAdministratifUniteLegale = 'A'
        AND e.activitePrincipaleEtablissement IN ('62.01Z','62.02A','62.02B')
) TO './export/sirene-ingenierie-logicielle.csv' (HEADER, DELIMITER ',');
