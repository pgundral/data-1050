USE hospital;
-- trigger to insert a row into alerts when an update
-- to prescriptions causes an adverse reaction

DROP TRIGGER IF EXISTS drug_interaction;

DELIMITER //

CREATE TRIGGER drug_interaction AFTER INSERT ON prescriptions
FOR EACH ROW
BEGIN
    -- insert into alerts
    INSERT INTO alerts (alert_date, drug1, drug2, patient_id, physician_id)
    -- get all of the possible interactions raised
    -- using DISTINCT only for p.drug_name (to avoid duplicates when a 
    -- drug was prescribed multiple times before)
    SELECT DISTINCT NEW.date, p.drug_name, NEW.drug_name, NEW.patient_id, NEW.physician_id
    FROM   prescriptions as p, 
           adverse_interactions as ai
    WHERE  NEW.patient_id = p.patient_id
    AND    ( (ai.drug_name = p.drug_name AND ai.drug_name_2 = NEW.drug_name)
    OR       (ai.drug_name = NEW.drug_name AND ai.drug_name_2 = p.drug_name) );
END //

DELIMITER ;