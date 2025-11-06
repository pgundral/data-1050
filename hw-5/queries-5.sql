-- 1. Find the names of all students who have taken or are currently taking 
-- (in Fall' 23) Data 1050.
SELECT s.name, t.course_id, t.year, t.semester
FROM student as s
INNER JOIN takes as t
ON s.ID = t.ID
AND t.course_id LIKE 'Data%1050';

-- 2. Find the names of students who have taken Data 1050 more than once. 
-- (This would also include students who are currently taking Data 1050 and have also 
-- taken it in a previous semester.)

SELECT name
FROM student
INNER JOIN (
    SELECT ID, COUNT(ID)
    FROM takes
    WHERE LOWER(course_id) LIKE '%data%1050%'
    GROUP BY ID
    HAVING COUNT(ID) > 1
) as takers
ON student.ID = takers.ID;

-- 3. For each department, find the total number of students who have taken 
-- classes offered by that department in Fall, 22. Do not include any department 
-- for which this total number is less than 2.

SELECT courses.dept_name, COUNT(*)
FROM takes
INNER JOIN
    (SELECT i.dept_name, t.course_id, 
    t.semester, t.year, t.sec_id
    FROM instructor as i
    INNER JOIN teaches as t
    ON i.ID = t.ID
    WHERE t.semester LIKE 'Fall'
    AND t.year = 2022) as courses
ON takes.sec_id = courses.sec_id
    AND takes.semester = courses.semester
    AND takes.year = courses.year
GROUP BY courses.dept_name
HAVING COUNT(*) > 2;

-- 4. For each instructor,  output the name of the instructor and the total number 
-- of students they have taught in any section of any course. 
-- That is, the total number of students they have ever taught.

WITH courses AS (
    SELECT i.name, t.course_id, t.sec_id, 
    t.year, t.semester
    FROM instructor as i, teaches as t
    WHERE i.ID = t.ID
)

SELECT c.name, COUNT(*)
FROM takes as t
INNER JOIN courses as c
ON t.course_id = c.course_id
    AND t.sec_id = c.sec_id
    AND t.year = c.year
    AND t.semester = c.semester
GROUP BY c.name;

-- 5. Find the id and names of instructors who have taught the least number of students.
CREATE OR REPLACE VIEW teach_counts AS
WITH courses AS (
    SELECT i.name, i.ID, t.course_id, t.sec_id, 
    t.year, t.semester
    FROM instructor as i, teaches as t
    WHERE i.ID = t.ID
)

SELECT c.name, c.ID, COUNT(*) as num_students
FROM takes as t
INNER JOIN courses as c
ON t.course_id = c.course_id
    AND t.sec_id = c.sec_id
    AND t.year = c.year
    AND t.semester = c.semester
GROUP BY c.name, c.ID
ORDER BY num_students;

SELECT * FROM teach_counts LIMIT 1;

-- 6. Find the names of any classes (identified by course_id and section) being taught 
-- in Fall '23 such that the number of students taking that class exceeds the capacity of 
-- the classroom in which the class is taught

WITH sec_capacities AS (
    SELECT s.semester, s.year, s.sec_id, 
    c.building, c.room_no, c.capacity
    FROM section s
    INNER JOIN classroom c
    ON s.building = c.building
        AND s.room_no = c.room_no
)

SELECT t.sec_id, t.semester, 
t.year, sc.capacity, COUNT(*)
FROM takes t
INNER JOIN sec_capacities sc
ON t.sec_id = sc.sec_id
    AND t.semester = sc.semester
    AND t.year = sc.year
GROUP BY t.sec_id, t.semester, t.year, sc.capacity
HAVING COUNT(*) > sc.capacity;