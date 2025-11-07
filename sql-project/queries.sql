USE hospital;
-- 1.
-- Find the physicians (ssn) who have most prescribed drugs which caused alerts 
-- (due to possible adverse interaction with a previously prescribed drug, not necessarily by the same physician).
WITH alert_ranks AS (
    SELECT p.ssn, COUNT(*) as count
    FROM physicians AS p
    INNER JOIN alerts AS a
    ON p.ssn = a.physician_id
    GROUP BY p.ssn
)

SELECT ssn, DENSE_RANK() OVER (
    ORDER BY count DESC
) as rank
FROM alert_ranks;

-- 2.
-- Find the physicians (ssn) who have prescribed two drugs to the same patient which have adverse interactions.

-- 3.
-- Find the physicians who have prescribed most drugs supplied by company DRUGXO.

-- 4.
-- For each drug supplied by company PHARMASEE display the price (per unit of quantity) 
-- charged by that company for that drug along with the average price charged for that drug 
-- (by companies, not pharmacies). Note: As it happens in the data we supplied each drug is supplied 
-- by only one company, but your query should not be based on that.

-- 5.
-- For each drug and for each pharmacy, find the percentage of the markup (per unit of quantity) for 
-- that drug by that pharmacy.

-- 6.
-- For each drug, find the average time between when a patient was prescribed a drug and when the 
-- prescription was filled at a pharmacy. (You will need to extract the components of a date to compute this.
-- mySQL provides functions for doing this and the official documentation here can help provide the appropriate 
-- functions: https://dev.mysql.com/doc/refman/8.4/en/date-and-time-functions.htmlLinks to an external site.).

-- 7.
-- For each pharmacy, find all the drugs that were prescribed to a patient and never filled at that pharmacy.