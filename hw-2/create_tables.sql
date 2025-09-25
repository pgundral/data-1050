USE data1050f25;

-- course
CREATE TABLE course (
    course_id VARCHAR(10) PRIMARY KEY,
    title VARCHAR(128),
    dept_name VARCHAR(128),
    credits INT,
    FOREIGN KEY(dept_name) REFERENCES department(dept_name)
);

-- prereq
CREATE TABLE prereq (
    course_id VARCHAR(128),
    prereq_id VARCHAR(128),
    PRIMARY KEY(course_id,prereq_id),
    FOREIGN KEY(course_id) REFERENCES course(course_id),
    FOREIGN KEY(prereq_id) REFERENCES course(course_id)
);

-- advisor
CREATE TABLE advisor (
    s_id VARCHAR(128) PRIMARY KEY,
    i_id VARCHAR(128),
    FOREIGN KEY(s_id) REFERENCES student(ID)
);

-- classroom
CREATE TABLE classroom (
    building VARCHAR(255),
    room_no INT,
    capacity INT,
    PRIMARY KEY(building,room_no)
);