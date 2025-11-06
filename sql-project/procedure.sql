-- stored procedure to retrieve (speciality, experience) <--
-- given (ssn) : from physicians
DELIMITER // 
CREATE PROCEDURE get_physician_info (
    IN ssn CHAR(11)
    OUT speciality VARCHAR(128),
        experience NUMERIC(2,0)

    BEGIN
        SELECT primary_speciality INTO speciality, 
               experience_years   INTO experience
        FROM physicians as p
        WHERE p.ssn = ssn
    END
)
