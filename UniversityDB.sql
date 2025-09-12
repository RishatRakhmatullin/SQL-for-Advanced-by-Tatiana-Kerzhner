/*1. Create the Database
-- You can skip this step if you already have a database created.*/
/*
select * from universitydb.departments; --4
select * from universitydb.classes; -- 6
select * from universitydb.courses; -- 6
select * from universitydb.enrollment; -- 8
select * from universitydb.grades; -- 4
select * from universitydb.instructors; -- 4
select * from universitydb.semesters; -- 2
select * from universitydb.students; -- 5
*/
DROP DATABASE IF EXISTS UniversityDB;
CREATE DATABASE IF NOT EXISTS UniversityDB;
USE UniversityDB;
/*2. Create Tables
Below are the 8 tables in a logical order to satisfy the foreign key constraints.
2.1 Departments
Stores information about the academic departments at the university.*/
DROP TABLE IF EXISTS Departments;
CREATE TABLE IF NOT EXISTS Departments (
    department_id   INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    building        VARCHAR(100),
    phone           VARCHAR(20)
);

/*2.2 Instructors
Stores information about instructors/professors who work in a specific department.*/
DROP TABLE IF EXISTS Instructors;
CREATE TABLE IF NOT EXISTS Instructors (
    instructor_id  INT AUTO_INCREMENT PRIMARY KEY,
    department_id  INT NOT NULL,
    first_name     VARCHAR(50) NOT NULL,
    last_name      VARCHAR(50) NOT NULL,
    email          VARCHAR(100),
    phone          VARCHAR(20),
    CONSTRAINT fk_instructors_departments
        FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);
/*2.3 Students
Stores information about students, including their major department.*/
DROP TABLE IF EXISTS Students;
CREATE TABLE IF NOT EXISTS Students (
    student_id          INT AUTO_INCREMENT PRIMARY KEY,
    first_name          VARCHAR(50) NOT NULL,
    last_name           VARCHAR(50) NOT NULL,
    email               VARCHAR(100),
    phone               VARCHAR(20),
    date_of_birth       DATE,
    major_department_id INT NOT NULL,
    CONSTRAINT fk_students_departments
        FOREIGN KEY (major_department_id) REFERENCES Departments(department_id)
);
/*2.4 Semesters
Defines the different semesters during which classes (course sections) are offered.*/
DROP TABLE IF EXISTS Semesters;
CREATE TABLE IF NOT EXISTS Semesters (
    semester_id   INT AUTO_INCREMENT PRIMARY KEY,
    semester_name VARCHAR(50) NOT NULL,     -- e.g., 'Fall 2024'
    start_date    DATE,
    end_date      DATE
);
/*2.5 Courses
Stores general information about courses (not specific sections).*/
DROP TABLE IF EXISTS Courses;
CREATE TABLE IF NOT EXISTS Courses (
    course_id     INT AUTO_INCREMENT PRIMARY KEY,
    department_id INT NOT NULL,
    course_name   VARCHAR(100) NOT NULL,
    credits       INT NOT NULL,
    CONSTRAINT fk_courses_departments
        FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);
/*2.6 Classes
Represents specific offerings (sections) of a course in a given semester, taught by a particular instructor.*/
DROP TABLE IF EXISTS Classes;
CREATE TABLE IF NOT EXISTS Classes (
    class_id      INT AUTO_INCREMENT PRIMARY KEY,
    course_id     INT NOT NULL,
    instructor_id INT NOT NULL,
    semester_id   INT NOT NULL,
    schedule_day  VARCHAR(20),   -- e.g., 'Mon/Wed/Fri'
    schedule_time VARCHAR(20),   -- e.g., '10:00AM - 11:15AM'
    room          VARCHAR(20),
    CONSTRAINT fk_classes_courses
        FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    CONSTRAINT fk_classes_instructors
        FOREIGN KEY (instructor_id) REFERENCES Instructors(instructor_id),
    CONSTRAINT fk_classes_semesters
        FOREIGN KEY (semester_id) REFERENCES Semesters(semester_id)
);
/*2.7 Enrollment
When a student enrolls in a particular class (section), we track that in this table.*/
DROP TABLE IF EXISTS Enrollment;
CREATE TABLE IF NOT EXISTS Enrollment (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id    INT NOT NULL,
    class_id      INT NOT NULL,
    enrollment_date DATE NOT NULL,
    CONSTRAINT fk_enrollment_students
        FOREIGN KEY (student_id) REFERENCES Students(student_id),
    CONSTRAINT fk_enrollment_classes
        FOREIGN KEY (class_id) REFERENCES Classes(class_id)
);
/*2.8 Grades
Stores the final or in-progress grade for a student in a specific enrollment record.*/
DROP TABLE IF EXISTS Grades;
CREATE TABLE IF NOT EXISTS Grades (
    grade_id      INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id INT NOT NULL,
    letter_grade  VARCHAR(2),   -- e.g., 'A', 'B+', 'C-' etc.
    CONSTRAINT fk_grades_enrollment
        FOREIGN KEY (enrollment_id) REFERENCES Enrollment(enrollment_id)
);
/*3. Insert Sample Data
Below are some sample records to populate the tables and demonstrate the relationships.
3.1 Departments*/

INSERT INTO Departments (department_name, building, phone)
VALUES
    ('Computer Science', 'Tech Hall', '+1-202-555-1010'),
    ('Mathematics',      'Science Bldg', '+1-202-555-2020'),
    ('English',          'Humanities Hall', '+1-202-555-3030'),
    ('Biology',          'Life Sciences Bldg', '+1-202-555-4040');
/*3.2 Instructors*/
INSERT INTO Instructors (department_id, first_name, last_name, email, phone)
VALUES
    (1, 'Alice',   'Johnson', 'alice.johnson@univ.edu', '+1-202-555-1111'), -- CS
    (1, 'Bob',     'Smith',   'bob.smith@univ.edu',     '+1-202-555-1112'), -- CS
    (2, 'Cindy',   'Brown',   'cindy.brown@univ.edu',   '+1-202-555-2221'), -- Math
    (3, 'Derek',   'Johnson', 'derek.johnson@univ.edu', '+1-202-555-3331'); -- English
/*3.3 Students*/
INSERT INTO Students (first_name, last_name, email, phone, date_of_birth, major_department_id)
VALUES
    ('Michael', 'Jordan',  'michael.jordan@students.univ.edu',  '+1-202-555-1001', '2003-05-06', 1),  -- CS major
    ('Sara',    'Connor',  'sara.connor@students.univ.edu',     '+1-202-555-1002', '2002-08-12', 2),  -- Math major
    ('Tony',    'Stark',   'tony.stark@students.univ.edu',      '+1-202-555-1003', '2003-01-10', 1),  -- CS major
    ('Diana',   'Prince',  'diana.prince@students.univ.edu',    '+1-202-555-1004', '2002-11-20', 3),  -- English major
    ('Bruce',   'Wayne',   'bruce.wayne@students.univ.edu',     '+1-202-555-1005', '2001-03-15', 1);  -- CS major
/*3.4 Semesters*/
INSERT INTO Semesters (semester_name, start_date, end_date)
VALUES
    ('Fall 2024',  '2024-08-26', '2024-12-15'),
    ('Spring 2025','2025-01-15', '2025-05-10');
/*3.5 Courses*/

INSERT INTO Courses (department_id, course_name, credits)
VALUES
    (1, 'Intro to Programming',    3),  -- CS
    (1, 'Data Structures',         4),  -- CS
    (2, 'Calculus I',              4),  -- Math
    (2, 'Linear Algebra',          3),  -- Math
    (3, 'English Literature I',    3),  -- English
    (3, 'Creative Writing',        3);  -- English
/*3.6 Classes*/

INSERT INTO Classes (course_id, instructor_id, semester_id, schedule_day, schedule_time, room)
VALUES
    -- Fall 2024 classes
    (1, 1, 1, 'Mon/Wed',  '10:00AM-11:15AM', 'Room 101'),  -- Intro to Programming, Alice Johnson, Fall 2024
    (3, 3, 1, 'Tue/Thu',  '09:00AM-10:15AM', 'Room 202'),  -- Calculus I, Cindy Brown, Fall 2024
    (5, 4, 1, 'Mon/Wed',  '11:30AM-12:45PM', 'Room 303'),  -- English Literature I, Derek Johnson, Fall 2024
    
    -- Spring 2025 classes
    (2, 2, 2, 'Mon/Wed',  '10:00AM-11:15AM', 'Room 104'),  -- Data Structures, Bob Smith, Spring 2025
    (4, 3, 2, 'Tue/Thu',  '12:00PM-01:15PM', 'Room 205'),  -- Linear Algebra, Cindy Brown, Spring 2025
    (6, 4, 2, 'Tue/Thu',  '02:00PM-03:15PM', 'Room 306');  -- Creative Writing, Derek Johnson, Spring 2025
/*3.7 Enrollment*/

INSERT INTO Enrollment (student_id, class_id, enrollment_date)
VALUES
    -- Fall 2024
    (1, 1, '2024-08-20'),  -- Michael Jordan in Intro to Programming (Fall 2024)
    (3, 1, '2024-08-21'),  -- Tony Stark in Intro to Programming (Fall 2024)
    (2, 2, '2024-08-22'),  -- Sara Connor in Calculus I (Fall 2024)
    (4, 3, '2024-08-23'),  -- Diana Prince in English Literature I (Fall 2024)

    -- Spring 2025
    (1, 4, '2025-01-10'),  -- Michael Jordan in Data Structures (Spring 2025)
    (5, 4, '2025-01-11'),  -- Bruce Wayne in Data Structures (Spring 2025)
    (2, 5, '2025-01-12'),  -- Sara Connor in Linear Algebra (Spring 2025)
    (4, 6, '2025-01-13');  -- Diana Prince in Creative Writing (Spring 2025)
/*3.8 Grades*/

INSERT INTO Grades (enrollment_id, letter_grade)
VALUES
    -- Let's say some fall grades have been assigned
    (1, 'A'),  -- Michael Jordan, Intro to Programming (Fall 2024)
    (2, 'A-'), -- Tony Stark, Intro to Programming (Fall 2024)
    (3, 'B+'), -- Sara Connor, Calculus I (Fall 2024)
    (4, 'B');  -- Diana Prince, English Literature I (Fall 2024)
    
