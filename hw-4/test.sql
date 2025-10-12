WITH changed AS (
    SELECT SUM(c.credits) as new_credits, 
        t.ID as ID
    FROM takes as t
        JOIN course as c
        ON t.course_id = c.course_id
    WHERE t.grade IS NULL
        AND t.ID IN ('1238', '1333')
    GROUP BY t.ID
)


SELECT *, (s.tot_cred + ch.new_credits) as new_total FROM
takes as t 
    JOIN student as s 
        ON t.ID = s.ID
    JOIN changed as ch 
        ON s.ID = ch.ID
WHERE t.grade IS NULL
AND t.ID IN ('1238', '1333');