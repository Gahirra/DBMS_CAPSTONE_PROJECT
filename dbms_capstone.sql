
USE adaptive_learning;
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    student_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    enrollment_date DATE NOT NULL,
    education_level VARCHAR(50)
);
CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100) NOT NULL,
    description TEXT,
    difficulty_level VARCHAR(30),
    duration INT,
    CHECK (duration > 0)
);
CREATE TABLE modules (
    module_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT NOT NULL,
    module_name VARCHAR(100) NOT NULL,
    module_number INT NOT NULL,

    FOREIGN KEY (course_id)
    REFERENCES courses(course_id),

    UNIQUE(course_id, module_number)
);
CREATE TABLE assessments (
    assessment_id INT PRIMARY KEY AUTO_INCREMENT,
    module_id INT NOT NULL,
    assessment_name VARCHAR(100) NOT NULL,
    total_marks INT NOT NULL,

    FOREIGN KEY (module_id)
    REFERENCES modules(module_id),

    CHECK (total_marks > 0)
);
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'active',

    active_course_id INT
    GENERATED ALWAYS AS (
        CASE
            WHEN status = 'active' THEN course_id
            ELSE NULL
        END
    ) STORED,

    FOREIGN KEY (student_id)
    REFERENCES students(student_id),

    FOREIGN KEY (course_id)
    REFERENCES courses(course_id),

    CHECK (
        status IN ('active', 'completed', 'cancelled')
    ),

    UNIQUE KEY uq_active_enrollment (
        student_id,
        active_course_id
    )
);
CREATE TABLE assessment_attempts (
    attempt_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    assessment_id INT NOT NULL,
    attempt_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    score DECIMAL(5,2) NOT NULL,

    FOREIGN KEY (student_id)
    REFERENCES students(student_id),

    FOREIGN KEY (assessment_id)
    REFERENCES assessments(assessment_id),

    CHECK (score >= 0)
);
CREATE TABLE learning_paths (
    path_id INT PRIMARY KEY AUTO_INCREMENT,
    path_name VARCHAR(100) NOT NULL,
    description TEXT
);
CREATE TABLE learning_path_modules (
    path_id INT NOT NULL,
    module_id INT NOT NULL,
    sequence_number INT NOT NULL,

    PRIMARY KEY (path_id, module_id),

    FOREIGN KEY (path_id)
    REFERENCES learning_paths(path_id),

    FOREIGN KEY (module_id)
    REFERENCES modules(module_id),

    UNIQUE(path_id, sequence_number)
);
CREATE TABLE module_progress (
    progress_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    module_id INT NOT NULL,
    completion_status VARCHAR(20)
        DEFAULT 'not_started',
    completion_date DATE,

    FOREIGN KEY (student_id)
    REFERENCES students(student_id),

    FOREIGN KEY (module_id)
    REFERENCES modules(module_id),

    UNIQUE(student_id, module_id),

    CHECK (
        completion_status IN (
            'not_started',
            'in_progress',
            'completed'
        )
    )
);
INSERT INTO students
(student_id, student_name, email, enrollment_date, education_level)
VALUES
(1, 'Asha', 'asha@gmail.com', '2026-01-10', 'Undergraduate'),
(2, 'Rohan', 'rohan@gmail.com', '2026-01-12', 'Undergraduate'),
(3, 'Meera', 'meera@gmail.com', '2026-01-15', 'Postgraduate'),
(4, 'Kabir', 'kabir@gmail.com', '2026-01-18', 'Undergraduate'),
(5, 'Isha', 'isha@gmail.com', '2026-01-20', 'Undergraduate');
INSERT INTO courses
(course_id, course_name, description, difficulty_level, duration)
VALUES
(101, 'Database Management System',
 'Learn SQL and database concepts', 'Beginner', 40),

(102, 'Python Programming',
 'Learn Python programming', 'Intermediate', 50);
 INSERT INTO modules
(module_id, course_id, module_name, module_number)
VALUES
(1001, 101, 'Introduction to DBMS', 1),
(1002, 101, 'SQL Basics', 2),
(1003, 101, 'Joins and Subqueries', 3),
(1004, 101, 'Advanced SQL', 4),

(2001, 102, 'Python Introduction', 1),
(2002, 102, 'Variables and Data Types', 2),
(2003, 102, 'Loops and Functions', 3),
(2004, 102, 'Advanced Python', 4);
INSERT INTO assessments
(assessment_id, module_id, assessment_name, total_marks)
VALUES
(5001, 1001, 'DBMS Test', 100),
(5002, 1002, 'SQL Test', 100),
(5003, 1003, 'Joins Test', 100),
(5004, 1004, 'Advanced SQL Test', 100),

(6001, 2001, 'Python Basics Test', 100),
(6002, 2002, 'Data Types Test', 100),
(6003, 2003, 'Functions Test', 100),
(6004, 2004, 'Advanced Python Test', 100);
INSERT INTO enrollments
(enrollment_id, student_id, course_id, enrollment_date, status)
VALUES
(1, 1, 101, '2026-01-10', 'active'),
(2, 2, 101, '2026-01-12', 'active'),
(3, 3, 101, '2026-01-15', 'active'),
(4, 4, 102, '2026-01-18', 'active'),
(5, 5, 102, '2026-01-20', 'active');
INSERT INTO learning_paths
(path_id, path_name, description)
VALUES
(301, 'DBMS Learning Path',
 'Complete DBMS from beginner to advanced'),

(302, 'Python Learning Path',
 'Complete Python from beginner to advanced');
 INSERT INTO learning_path_modules
(path_id, module_id, sequence_number)
VALUES
(301, 1001, 1),
(301, 1002, 2),
(301, 1003, 3),
(301, 1004, 4),

(302, 2001, 1),
(302, 2002, 2),
(302, 2003, 3),
(302, 2004, 4);
INSERT INTO module_progress
(student_id, module_id, completion_status, completion_date)
VALUES
(1, 1001, 'completed', '2026-02-01'),
(1, 1002, 'completed', '2026-02-05'),
(1, 1003, 'in_progress', NULL),

(2, 1001, 'completed', '2026-02-02'),

(3, 1001, 'completed', '2026-02-01'),
(3, 1002, 'completed', '2026-02-03'),
(3, 1003, 'completed', '2026-02-06'),

(4, 2001, 'completed', '2026-02-02'),
(4, 2002, 'completed', '2026-02-05'),

(5, 2001, 'completed', '2026-02-03');
INSERT INTO assessment_attempts
(attempt_id, student_id, assessment_id, attempt_date, score)
VALUES
(1, 1, 5001, '2026-02-01 10:00:00', 70),
(2, 1, 5001, '2026-02-02 10:00:00', 80),
(3, 1, 5002, '2026-02-06 10:00:00', 75),
(4, 1, 5003, '2026-02-10 10:00:00', 60),

(5, 2, 5001, '2026-02-02 10:00:00', 90),
(6, 2, 5002, '2026-02-07 10:00:00', 85),

(7, 3, 5001, '2026-02-01 10:00:00', 50),
(8, 3, 5002, '2026-02-04 10:00:00', 65),
(9, 3, 5003, '2026-02-07 10:00:00', 70),
(10, 3, 5004, '2026-02-10 10:00:00', 88),

(11, 4, 6001, '2026-02-02 10:00:00', 80),
(12, 4, 6002, '2026-02-06 10:00:00', 72),
(13, 4, 6003, '2026-02-10 10:00:00', 90),

(14, 5, 6001, '2026-02-03 10:00:00', 40),
(15, 5, 6002, '2026-02-08 10:00:00', 55);
SELECT * FROM students;
SELECT * FROM courses;
SELECT * FROM modules;

SELECT * FROM assessments;
SELECT * FROM enrollments;
SELECT * FROM assessment_attempts;
SELECT * FROM learning_paths;
SELECT * FROM learning_path_modules;
SELECT * FROM module_progress;

SELECT
    s.student_id,
    s.student_name,
    c.course_name,
    e.status
FROM students s
JOIN enrollments e
    ON s.student_id = e.student_id
JOIN courses c
    ON e.course_id = c.course_id;
    
SELECT
    s.student_name,
    c.course_name,
    ROUND(AVG(aa.score), 2) AS average_score,
       CASE
        WHEN AVG(aa.score) < 50
            THEN 'Provide beginner-level content'

        WHEN AVG(aa.score) < 70
            THEN 'Provide additional practice'

        WHEN AVG(aa.score) < 85
            THEN 'Continue with intermediate modules'

        ELSE 'Recommend advanced modules'
    END AS recommendation
FROM students s
JOIN enrollments e
    ON s.student_id = e.student_id
JOIN courses c
    ON e.course_id = c.course_id
JOIN modules m
    ON c.course_id = m.course_id
JOIN assessments a
    ON m.module_id = a.module_id
JOIN assessment_attempts aa
    ON a.assessment_id = aa.assessment_id
GROUP BY
    s.student_id,
    s.student_name,
    c.course_id,
    c.course_name;
    
CREATE INDEX idx_enrollments_student_course
ON enrollments(student_id, course_id);

CREATE INDEX idx_attempts_student_assessment_date
ON assessment_attempts(
    student_id,
    assessment_id,
    attempt_date
);
 CREATE UNIQUE INDEX uq_active_enrollment ON
    enrollments(  active_course_id);
    
EXPLAIN
SELECT *
FROM enrollments
WHERE student_id = 1
AND course_id = 101;


CREATE OR REPLACE VIEW student_average_view AS

SELECT
    aa.student_id,
    m.course_id,
    ROUND(AVG(aa.score), 2) AS average_score
FROM assessment_attempts aa
JOIN assessments a
ON aa.assessment_id = a.assessment_id
JOIN modules m
ON a.module_id = m.module_id
GROUP BY
    aa.student_id,
    m.course_id;

CREATE OR REPLACE VIEW student_progress_view AS

SELECT
    s.student_id,
    s.student_name,
    c.course_name,

    SUM(
        CASE
            WHEN mp.completion_status = 'completed'
            THEN 1
            ELSE 0
        END
    ) AS modules_completed,

    ROUND(
        SUM(
            CASE
                WHEN mp.completion_status = 'completed'
                THEN 1
                ELSE 0
            END
        ) * 100 / COUNT(m.module_id), 2
    ) AS completion_percentage,

    sav.average_score
FROM students s
JOIN enrollments e
ON s.student_id = e.student_id
JOIN courses c
ON e.course_id = c.course_id
JOIN modules m
ON c.course_id = m.course_id
LEFT JOIN module_progress mp
ON s.student_id = mp.student_id
AND m.module_id = mp.module_id
LEFT JOIN student_average_view sav
ON s.student_id = sav.student_id
AND c.course_id = sav.course_id
GROUP BY
s.student_id,s.student_name,c.course_id,c.course_name,sav.average_score;
SELECT * FROM student_progress_view;



CREATE OR REPLACE VIEW learning_recommendation_view AS

SELECT
    s.student_id,
    s.student_name,
    lp.path_name,
    m.module_id,
    m.module_name,
    lpm.sequence_number

FROM students s

JOIN enrollments e
ON s.student_id = e.student_id

JOIN courses c
ON e.course_id = c.course_id

JOIN learning_paths lp
ON c.course_id = lp.path_id - 200

JOIN learning_path_modules lpm
ON lp.path_id = lpm.path_id

JOIN modules m
ON lpm.module_id = m.module_id

LEFT JOIN module_progress mp
ON s.student_id = mp.student_id
AND m.module_id = mp.module_id

WHERE e.status = 'active'
AND (mp.completion_status IS NULL
OR mp.completion_status <> 'completed');
SELECT * FROM learning_recommendation_view;


SELECT
    c.course_id,
    s.student_id,
    s.student_name,
    ROUND(AVG(aa.score), 2) AS average_score,

    RANK() OVER (
        PARTITION BY c.course_id
        ORDER BY AVG(aa.score) DESC
    ) AS course_rank

FROM students s

JOIN assessment_attempts aa
ON s.student_id = aa.student_id

JOIN assessments a
ON aa.assessment_id = a.assessment_id

JOIN modules m
ON a.module_id = m.module_id

JOIN courses c
ON m.course_id = c.course_id

GROUP BY
    c.course_id,
    s.student_id,
    s.student_name

ORDER BY
    c.course_id,
    course_rank;




SELECT
    s.student_name,
    a.assessment_name,
    result.previous_score,
    result.score AS latest_score

FROM (
    SELECT
        student_id,
        assessment_id,
        attempt_date,
        attempt_id,
        score,

        LAG(score) OVER (
            PARTITION BY student_id, assessment_id
            ORDER BY attempt_date, attempt_id
        ) AS previous_score

    FROM assessment_attempts
) AS result

JOIN students s
    ON result.student_id = s.student_id

JOIN assessments a
    ON result.assessment_id = a.assessment_id

WHERE result.attempt_id = (
    SELECT MAX(aa.attempt_id)
    FROM assessment_attempts aa
    WHERE aa.student_id = result.student_id
    AND aa.assessment_id = result.assessment_id
)
AND result.previous_score IS NOT NULL
AND result.score < result.previous_score;



SELECT s.student_name,aa.assessment_id,aa.attempt_date,aa.score,

    ROUND(
        AVG(aa.score) OVER (
            PARTITION BY aa.student_id
            ORDER BY aa.attempt_date
        ), 2
    ) AS running_average

FROM assessment_attempts aa
JOIN students s
ON aa.student_id = s.student_id
ORDER BY aa.student_id, aa.attempt_date;

SELECT student_id,student_name,
    ROUND(average_score, 2) AS average_score,
	CASE
        WHEN learner_group = 1 THEN 'Beginner'
        WHEN learner_group = 2 THEN 'Intermediate'
        ELSE 'Advanced'
    END AS learner_level

FROM (
    SELECT
        student_id,
        student_name,
        average_score,

        NTILE(3) OVER (
            ORDER BY average_score, student_id
        ) AS learner_group
FROM (
        SELECT s.student_id, s.student_name,
            AVG(aa.score) AS average_score
        FROM students s
        JOIN assessment_attempts aa
            ON s.student_id = aa.student_id
        GROUP BY s.student_id, s.student_name
    ) AS scores
) AS groups_result
ORDER BY average_score;



