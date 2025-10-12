USE data1050f25;
-- 5. Write a SQL instruction so that all students with ID 1238 and 1333 who have a 
-- null grade in any course, have their grade changed to 'A'.

-- start transaction so changes aren't permanent yet
START TRANSACTION;

-- make a CTE to store courses changed
WITH changed AS (
    SELECT SUM(c.credits) as new_creds, 
        t.ID as ID
    FROM takes as t
        JOIN course as c
        ON t.course_id = c.course_id
    WHERE t.grade IS NULL
        AND t.ID IN ('1238', '1333')
    GROUP BY t.ID
)

-- 6. After executing this instruction write a query to make appropriate changes to 
-- the tot_credit of those students (that is, increment it by the credits assigned to 
-- those courses where the grade was changed.)

-- execute a joint update of takes and student
UPDATE takes as t 
    JOIN student as s 
        ON t.ID = s.ID
    JOIN changed as ch 
        ON s.ID = ch.ID
SET s.tot_cred = s.tot_cred + ch.new_creds,
    t.grade = 'A'
WHERE t.grade IS NULL
AND t.ID IN ('1238', '1333');

-- SELECT * FROM student;
-- SELECT * FROM takes;

-- 7. After executing the instructions for 4 and 5, write a query to return the ID and names 
-- of those students who have the most credits.

SELECT ID, name, tot_cred 
FROM student
WHERE tot_cred = 
    (SELECT max(tot_cred) FROM student);


ROLLBACK;

-- NOTE: MYSQL8 treats a (non-recursive) CTE as a named view, so the data isn't materialized. 
-- This means the later update statement alters the contents of the CTE 'changed', meaning its contents 
-- (ch.new_creds) must be accessed BEFORE the t.grade = 'A' change takes place within the `SET` clause.
