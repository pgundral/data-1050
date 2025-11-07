USE hospital;
-- stored procedure to retrieve (speciality, experience) <--
-- given (ssn) : from physicians
DELIMITER // 
CREATE procedure get_physician_info (
    IN ssn CHAR(11),
    OUT speciality VARCHAR(128),
    OUT experience NUMERIC(2,0)
    )

BEGIN
    SELECT primary_speciality, experience_years
    INTO speciality, experience
    FROM physicians as p
    WHERE p.ssn = ssn;
END //

DELIMITER ;
