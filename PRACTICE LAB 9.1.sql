create database clg;
use clg;

CREATE TABLE Student (
    student_id INT PRIMARY KEY,
    name       VARCHAR(50) NOT NULL,
    city       VARCHAR(50)
);
 
INSERT INTO Student (student_id, name, city) VALUES
(1, 'Asha',  'Pune'),
(2, 'Ravi',  'Mumbai'),
(3, 'Meera', 'Pune'),
(4, 'Kiran', 'Nagpur'),
(5, 'Sana',  'Mumbai'),
(6, 'Dev',   'Pune');
 

CREATE TABLE Course (
    course_id       VARCHAR(5) PRIMARY KEY,
    course_name     VARCHAR(50) NOT NULL,
    duration_months INT,
    total_fee       INT
);
 
INSERT INTO Course (course_id, course_name, duration_months, total_fee) VALUES
('C1', 'SQL',      2, 15000),
('C2', 'Excel',    1,  8000),
('C3', 'Python',   3, 25000),
('C4', 'Power BI', 2, 18000);
 

CREATE TABLE Enrollment (
    enroll_id   VARCHAR(5) PRIMARY KEY,
    student_id  INT        NOT NULL,
    course_id   VARCHAR(5) NOT NULL,
    enroll_date DATE,
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (course_id)  REFERENCES Course(course_id)
);
 
INSERT INTO Enrollment (enroll_id, student_id, course_id, enroll_date) VALUES
('E1', 1, 'C1', '2026-01-10'),
('E2', 1, 'C2', '2026-02-05'),
('E3', 2, 'C1', '2026-01-15'),
('E4', 3, 'C3', '2026-02-01'),
('E5', 3, 'C1', '2026-02-10'),
('E6', 4, 'C2', '2026-03-01'),
('E7', 5, 'C3', '2026-03-05'),
('E8', 2, 'C3', '2026-03-12');
 

CREATE TABLE Fee (
    fee_id       VARCHAR(5) PRIMARY KEY,
    enroll_id    VARCHAR(5) NOT NULL,
    amount_paid  INT,
    payment_date DATE,
    mode         VARCHAR(10),
    FOREIGN KEY (enroll_id) REFERENCES Enrollment(enroll_id)
);
 
INSERT INTO Fee (fee_id, enroll_id, amount_paid, payment_date, mode) VALUES
('F1', 'E1', 15000, '2026-01-10', 'UPI'),
('F2', 'E2',  4000, '2026-02-05', 'Cash'),
('F3', 'E2',  4000, '2026-02-20', 'UPI'),
('F4', 'E3', 10000, '2026-01-15', 'Card'),
('F5', 'E4', 25000, '2026-02-01', 'UPI'),
('F6', 'E5', 15000, '2026-02-10', 'Cash'),
('F7', 'E6',  8000, '2026-03-01', 'Card'),
('F8', 'E7', 12000, '2026-03-05', 'UPI');
 

SELECT * FROM Student;
SELECT * FROM Course;
SELECT * FROM Enrollment;
SELECT * FROM Fee;

 -- 4. Show the enroll_id and amount_paid for every payment.
 select e.enroll_id,f.amount_paid from enrollment e
 inner join fee f
 on e.enroll_id = f.enroll_id;
-- 5. Show the student name and amount_paid for every payment.
select s.name,f.amount_paid from student s
inner join enrollment e
on s.student_id = e.student_id
inner join fee f
on e.enroll_id = f.enroll_id;

-- 6. Show the course_name and total amount_paid for every payment.
select c.course_name,f.amount_paid from course c 
inner join enrollment e
on c.course_id = e.course_id
inner join fee f
on e.enroll_id = f.enroll_id;

-- 7. Show the student name, course_name and amount_paid for every payment (all four tables).
select s.name,c.course_name,f.amount_paid from student s
inner join enrollment e
on s.student_id = e.student_id
inner join fee f
on e.enroll_id = f.enroll_id
inner join course c
on e.course_id = c.course_id;

-- 8. Show all students with the courses they enrolled in, including students who have not enrolled anywhere.
select s.name,c.course_name from student s
left join enrollment e
on s.student_id = e.student_id
left join course c
on e.course_id = c.course_id;

-- 9. Show all courses with the names of students enrolled, including courses that have no students.
select c.course_name,s.name from course c
left join enrollment e
on c.course_id = c.course_id
left join student s
on e.student_id = s.student_id;

-- 10. Show every enrollment with its payments, including enrollments that have no payment yet.
select e.enroll_id,f.amount_paid from enrollment e
left join fee f
on e.enroll_id = f.enroll_id;

-- 11. Show the names of students from Pune who enrolled in the SQL course.
select * from student s
inner join enrollment e
on s.student_id = e.student_id
inner join course c
on e.course_id = c.course_id
where city="pune" and c.course_name="sql";

-- 12. Show the total amount paid by each student, highest first.
select name,sum(amount_paid) from student s
inner join enrollment e
on s.student_id = e.student_id
inner join fee f
on e.enroll_id = f.enroll_id
group by name
order by sum(amount_paid) desc;

-- 13. Show the number of students enrolled in each course, with the most popular course first.
select course_name,count(*) from student s
inner join enrollment e 
on s.student_id = e.student_id 
inner join course c
on e.course_id = c.course_id
group by course_name
order by count(*) desc;

-- 14. Show the names of students who enrolled in more than one course.
select name,count(*) from student s
inner join enrollment e
on s.student_id = e.student_id
inner join course c
on e.course_id = c.course_id
group by name 
having count(*) >1;

-- 15. Show the total fee collected per course, but only for courses where the total is above 20000.
select c.course_name,sum(amount_paid) from student s
inner join enrollment e
on s.student_id = e.student_id
inner join course c
on e.course_id = c.course_id
inner join fee f
on e.enroll_id = f.enroll_id
group by course_name;

-- 16. Show the total amount collected for each payment mode, from highest to lowest.
select mode,sum(amount_paid) from fee
group by mode
order by sum(amount_paid) desc;

-- 17. Show the courses that have no enrollment at all.
select c.course_name,e.enroll_id from course c
left join enrollment e
on c.course_id = e.course_id
where e.enroll_id is null;

-- 18. For each enrollment, show the student name, course_name and balance (course total_fee minus total paid). 
-- Keep only enrollments with a balance above 0, largest balance first. Include enrollments with no payment.
select s.name,c.course_name,c.total_fee,f.amount_paid,total_fee-amount_paid as balance from enrollment e
left join student s
on e.student_id = s.student_id
left join course c
on e.course_id = c.course_id
left join fee f
on e.enroll_id = f.enroll_id
where total_fee-amount_paid>0 or amount_paid is null;

-- 19. Show the total fee collected per city, only for cities where the total is above 15000, highest first.
select s.city,sum(amount_paid) from student s
inner join enrollment e
on s.student_id = e.student_id


inner join fee f
on e.enroll_id = f.enroll_id
where amount_paid >=15000
group by city
order by sum(amount_paid) desc;

-- 20. Show the top 3 students by total amount paid.
select s.name,sum(amount_paid) from student s
inner join enrollment e
on s.student_id = e.student_id
inner join fee f
on e.enroll_id = f.enroll_id
group by s.name
order by sum(amount_paid) desc limit 3;

select * from course c
join student s;

SELECT * FROM Student;
SELECT * FROM Course;
SELECT * FROM Fee;
select * from Enrollment

-- Display the courses whose total_fee is greater than the average total_fee of all courses.

-- Find the course (name and fee) with the highest total_fee.

-- List the students who live in the same city as Asha (exclude Asha herself).

-- Display the enrollments made on the earliest enroll_date.
where enroll_date =
(select min(enroll_date) from Enrollment);

-- Show the complete fee record of the payment with the highest amount_paid.
select * from fee
where amount_paid >=(select max(amount_paid) from fee);

-- List the courses that have a lower total_fee than the SQL course.
select * from course
where total_fee <(select total_fee from course where course_name ="sql");

-- Display the names of students who are enrolled in at least one course.
select * from student
where student_id in
(select student_id from enrollment);

-- Display the names of students who have not enrolled in any course.
select * from student
where student_id not in
(select student_id from enrollment);

-- List the courses that no student has enrolled in.
select * from course
where course_id not in
(select course_id from enrollment);

-- Show the enrollments for which at least one payment was made via UPI.
select * from enrollment
where enroll_id in(select enroll_id from fee where mode ="upi");

-- Display the names of students who enrolled in the SQL course.
select * from student
where student_id in(select student_id from enrollment 
where course_id =(select course_id from course where course_name="sql"));

-- List the courses whose total_fee is greater than ANY course with a duration of 2 months.
select * from course
where total_fee >any (select total_fee from course where duration_months = 2);

-- List the courses whose total_fee is greater than ALL courses with a duration of 2 months.
select * from course
where total_fee >all (select total_fee from course where duration_months = 2);

-- Display the enrollments that have no payment record in the Fee table 
select * from enrollment
where enroll_id not in(select enroll_id from fee );

-- Display the names of courses in which students from Mumbai have enrolled.
select * from course
where course_id in (select course_id from enrollment where student_id in(
select student_id from student where city ="mumbai"));

-- Display the names of students who paid at least one fee in Cash. (Student → Enrollment → Fee)
select * from student
where student_id in (select student_id from enrollment where enroll_id in
(select enroll_id from fee where mode ="cash"));

-- Display the names of courses for which at least one payment was made by Card.
select * from course 
where course_id in(select course_id from enrollment where enroll_id in 
(select enroll_id from fee where mode ="card"));

-- List the students enrolled in courses whose total_fee is greater than the average total_fee. (Student → Enrollment → Course → AVG)
select * from student
where student_id in (select (student_id) from enrollment where course_id in 
(select course_id from course where total_fee >(select avg(total_fee) from course)));

-- Display the cities of students who made a payment greater than the average amount_paid.
select * from student
where student_id in(select student_id from enrollment where enroll_id in
(select enroll_id from fee where amount_paid >(select avg(amount_paid) from fee)));