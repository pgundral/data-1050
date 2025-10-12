-- USE data1050f25;

-- 1. Find the id, title and section_id of all the courses being taught in Fall 2023.
SELECT c.course_id, title, sec_id
FROM course as c INNER JOIN section as s
ON c.course_id = s.course_id
AND year = 2023
AND semester LIKE '%Fall%';

-- 2. Find the id, title, section_id, and instructor name of all courses being taught in Fall 2023
SELECT course.course_id, course.title, section.sec_id, instructor.name
FROM course, section, teaches, instructor
WHERE course.course_id = section.course_id
AND section.course_id = teaches.course_id
AND teaches.ID = instructor.ID
AND section.semester LIKE '%Fall%'
AND section.year = 2023;

-- 3. Write a SQL instruction to change (i.e., update) the time_slot_id of all courses which are 6 to 2. 
-- You may not delete these and insert new ones; use the update command.
UPDATE section SET time_slot_id = 2 WHERE time_slot_id = 6;
-- SELECT * FROM section;

-- 4. Find the course id, title, section and start time of all courses taught in Fall 2022
SELECT c.course_id, c.title, s.sec_id, ts.start_time
FROM course as c, section as s, time_slot as ts
WHERE c.course_id = s.course_id
AND s.time_slot_id = ts.time_slot_id
AND s.semester LIKE '%Fall%'
AND s.year = 2022;
