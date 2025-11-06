-- trigger to insert a row into alerts when an update
-- to prescriptions causes an adverse reaction

DELIMITER //

CREATE trigger drug_interaction AFTER INSERT ON prescriptions
FOR EACH ROW
BEGIN
    DECLARE interaction_drug VARCHAR(128);

    -- get all of the possible interactions 
    -- pick the first
    SELECT drug_name
        INTO interaction_drug
    FROM adverse_interactions as ai
    INNER JOIN prescriptions as p
        ON ai.drug_name == p.drug_name
    WHERE nrow.drug_name == drug_name_2
        AND nrow.patient_id == ai.patient_id
    LIMIT 1;

    -- check if an interaction exists
    -- if so, insert
    IF interaction_drug IS NOT NULL THEN
        INSERT INTO alerts
        VALUES (
            NEW.patient_id,
            NEW.physician_id,
            NEW.date,
            interaction_drug,
            NEW.drug_name
        );
    END IF;
END //

DELIMITER ;