USE hospital;
-- 1.
-- Find the physicians (ssn) who have most prescribed drugs which caused alerts 
-- (due to possible adverse interaction with a previously prescribed drug, not necessarily by the same physician).
WITH alert_rankings AS (
    SELECT physician_id, DENSE_RANK() OVER(
        ORDER BY COUNT(*) DESC
    ) as alert_rank
    FROM alerts
    GROUP BY physician_id
)

SELECT physician_id
FROM alert_rankings
WHERE alert_rank = 1;

-- 2.
-- Find the physicians (ssn) who have prescribed two drugs to the same patient which have adverse interactions.

SELECT DISTINCT p1.physician_id
FROM prescriptions as p1,
     prescriptions as p2
WHERE p1.physician_id = p2.physician_id
AND p1.drug_name != p2.drug_name
AND p1.patient_id = p2.patient_id
AND p2.drug_name IN (
    SELECT drug_name_2
    FROM adverse_interactions
    WHERE drug_name = p1.drug_name
);

-- 3.
-- Find the physicians who have prescribed most drugs supplied by company DRUGXO.
WITH drugxo_fills AS (
    SELECT pf.prescription_id
    FROM pharmacy_fills as pf, contracts as con, companies as comp
    WHERE con.company_id = comp.id
    AND pf.pharmacy_id = con.pharmacy_id
    AND comp.name LIKE "%DRUGXO%"
)

SELECT DISTINCT physician_id
FROM prescriptions as p
JOIN drugxo_fills as dgxo
ON p.id = dgxo.prescription_id;

-- 4.
-- For each drug supplied by company PHARMASEE display the price (per unit of quantity) 
-- charged by that company for that drug along with the average price charged for that drug 
-- (by companies, not pharmacies). Note: As it happens in the data we supplied each drug is supplied 
-- by only one company, but your query should not be based on that.
SELECT (price/quantity) as price_per_unit, AVG(price/quantity) OVER (
    PARTITION BY drug_name
) as avg_price_per_unit
FROM contracts
WHERE company_id = (SELECT id FROM companies WHERE name LIKE "%PHARMASEE%");

-- 5.
-- For each drug and for each pharmacy, find the percentage of the markup (per unit of quantity) for 
-- that drug by that pharmacy.
-- get revenue of drug
CREATE VIEW revenue AS
    SELECT p.id, pharmacy_id, drug_name, 
    SUM(quantity) OVER (
        PARTITION BY pharmacy_id, drug_name
    ) as sum_quantity,
    SUM(cost) OVER (
        PARTITION BY pharmacy_id, drug_name
    ) as sum_cost
    FROM pharmacy_fills as pf
    JOIN prescriptions as p
    ON p.id = pf.prescription_id;

CREATE VIEW total_cost AS
    SELECT pharmacy_id, drug_name,
    SUM(quantity) OVER (
        PARTITION BY pharmacy_id, company_id
    ) as sum_quantity,
    SUM(price) OVER (
        PARTITION BY pharmacy_id, company_id
    ) as sum_price
    FROM contracts;

SELECT r.pharmacy_id, r.drug_name,
       (
        ( (r.sum_cost/r.sum_quantity) - 
        (tc.sum_price/tc.sum_quantity) ) / 
        (tc.sum_price/tc.sum_quantity) 
        ) as markup
FROM revenue as r
JOIN total_cost as tc
ON r.pharmacy_id = tc.pharmacy_id
AND r.drug_name = tc.drug_name;

-- 6.
-- For each drug, find the average time between when a patient was prescribed a drug and when the 
-- prescription was filled at a pharmacy. (You will need to extract the components of a date to compute this.
-- mySQL provides functions for doing this and the official documentation here can help provide the appropriate 
-- functions: https://dev.mysql.com/doc/refman/8.4/en/date-and-time-functions.htmlLinks to an external site.).
WITH dates AS (
    SELECT drug_name, STR_TO_DATE(p.date, '%m/%d/%Y') as scrip_date, 
    STR_TO_DATE(pf.date, '%m/%d/%Y') as fill_date,
    DATEDIFF(STR_TO_DATE(pf.date, '%m/%d/%Y'), 
        STR_TO_DATE(p.date, '%m/%d/%Y')) as diff
    FROM prescriptions as p
    JOIN pharmacy_fills as pf
    ON p.id = pf.prescription_id
)

SELECT drug_name, AVG(IF(diff < 0, null, diff)) as avg_diff
FROM dates
GROUP BY drug_name;

-- 7.
-- For each pharmacy, find all the drugs that were prescribed to a patient and never filled at that pharmacy.

SELECT pharmacies.name, drug_name
FROM (
    -- get all the drugs prescribed and who filled it
    (SELECT pf.pharmacy_id, p.drug_name
    FROM prescriptions as p
    JOIN pharmacy_fills as pf
    ON p.id = pf.prescription_id) 
    EXCEPT
    -- get all the drugs offered by each pharmacy
    (SELECT pharmacy_id, drug_name
    FROM contracts)
) as result
JOIN pharmacies
ON result.pharmacy_id = pharmacies.id
ORDER BY result.pharmacy_id;