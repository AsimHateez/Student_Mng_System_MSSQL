-- Updated Student Management System (v2) - MS SQL Server



USE std_mng_sys;
GO

-- Create the Student table
CREATE TABLE Student (
  StudentID INT PRIMARY KEY,
  Name VARCHAR(50) NOT NULL,
  Age INT CHECK (Age >= 10 AND Age <= 100),
  Gender VARCHAR(10) CHECK (Gender IN ('M', 'F')),
  Email VARCHAR(100) UNIQUE NOT NULL,
  PhoneNumber VARCHAR(20) UNIQUE NOT NULL
);

-- Create the Course table
CREATE TABLE Course (
  CourseID INT PRIMARY KEY,
  Name VARCHAR(50) NOT NULL,
  Description VARCHAR(100),
  Credits INT CHECK (Credits >= 1 AND Credits <= 5)
);

-- Create the Enrollment table
CREATE TABLE Enrollment (
  EnrollmentID INT PRIMARY KEY,
  StudentID INT,
  CourseID INT,
  EnrollmentDate DATE DEFAULT GETDATE(),
  FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
  FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

-- Create the Teacher table
CREATE TABLE Teacher (
  TeacherID INT PRIMARY KEY,
  Name VARCHAR(50) NOT NULL,
  Age INT CHECK (Age >= 18 AND Age <= 70),
  Gender VARCHAR(10) CHECK (Gender IN ('M', 'F')),
  Email VARCHAR(100) UNIQUE NOT NULL,
  PhoneNumber VARCHAR(20) UNIQUE NOT NULL,
  Designation VARCHAR(50)
);

-- Create the Timetable table
CREATE TABLE Timetable (
  TimetableID INT PRIMARY KEY,
  CourseID INT,
  TeacherID INT,
  DayOfWeek VARCHAR(10) CHECK (DayOfWeek IN ('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday')),
  StartTime TIME,
  EndTime TIME,
  RoomNumber VARCHAR(10),
  FOREIGN KEY (CourseID) REFERENCES Course(CourseID),
  FOREIGN KEY (TeacherID) REFERENCES Teacher(TeacherID)
);

-- Create the Attendance table
CREATE TABLE Attendance (
  AttendanceID INT PRIMARY KEY,
  StudentID INT,
  CourseID INT,
  AttendanceDate DATE DEFAULT GETDATE(),
  AttendanceTime TIME DEFAULT GETDATE(),
  Status VARCHAR(10) CHECK (Status IN ('Present','Absent')),
  FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
  FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

-- Sample INSERT Statements
INSERT INTO Student VALUES (1, 'Asim', 20, 'M', 'asimhateez@gmail.com', '03001234567');
INSERT INTO Student VALUES (2, 'Sara', 22, 'F', 'sara@example.com', '03012345678');

INSERT INTO Course VALUES (101, 'Database Systems', 'Learn SQL & DB design', 3);
INSERT INTO Course VALUES (102, 'OOP in Java', 'Object-oriented concepts', 4);

INSERT INTO Teacher VALUES (1, 'Mr. Khan', 40, 'M', 'khan@example.com', '03111222333', 'Senior Lecturer');

INSERT INTO Enrollment VALUES (1, 1, 101, '2025-01-15');
INSERT INTO Enrollment VALUES (2, 2, 102, DEFAULT);

INSERT INTO Timetable VALUES (1, 101, 1, 'Monday', '09:00', '10:30', 'R101');

INSERT INTO Attendance VALUES (1, 1, 101, DEFAULT, DEFAULT, 'Present');
INSERT INTO Attendance VALUES (2, 2, 102, '2025-06-25', '10:00', 'Absent');


--some test cases


SELECT * FROM Student;
SELECT * FROM Course;
SELECT * FROM Enrollment;

-- Get full timetable with course and teacher info
SELECT t.DayOfWeek, t.StartTime, t.EndTime, c.Name AS Course, te.Name AS Teacher
FROM Timetable t
JOIN Course c ON t.CourseID = c.CourseID
JOIN Teacher te ON t.TeacherID = te.TeacherID;



-- Get students enrolled in 'Database Systems'
SELECT s.Name, c.Name AS Course
FROM Enrollment e
JOIN Student s ON e.StudentID = s.StudentID
JOIN Course c ON e.CourseID = c.CourseID
WHERE c.Name = 'Database Systems';

-- Find all students marked 'Absent'
SELECT s.Name, a.AttendanceDate, a.Status
FROM Attendance a
JOIN Student s ON a.StudentID = s.StudentID
WHERE a.Status = 'Absent';

-- Get attendance records for a specific date
SELECT * FROM Attendance WHERE AttendanceDate = '2025-06-25';


-- Count how many students are enrolled in each course
SELECT c.Name, COUNT(e.StudentID) AS Total_Enrolled
FROM Course c
LEFT JOIN Enrollment e ON c.CourseID = e.CourseID
GROUP BY c.Name;

-- Count Present vs Absent students
SELECT Status, COUNT(*) AS Total
FROM Attendance
GROUP BY Status;


