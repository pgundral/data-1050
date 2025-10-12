-- 5. Write a SQL instruction so that all students with ID 1238 and 1333 who have a 
-- null grade in any course, have their grade changed to 'A'.
-- UPDATE takes SET grade = 'A' 
-- WHERE grade IS NULL
-- AND (ID = '1238' OR ID = '1333');
SELECT * FROM takes;

-- 6. After executing this instruction write a query to make appropriate changes to 
-- the tot_credit of those students (that is, increment it by the credits assigned to 
-- those courses where the grade was changed.)

-- 7. After executing the instructions for 4 and 5, write a query to return the ID and names 
-- of those students who have the most credits.