use class6

drop table if exists Employees;
drop table if exists Departments;
drop table if exists Projects;
CREATE TABLE Departments (
    DepartmentID INT,
    DepartmentName VARCHAR(50) NOT NULL
);

CREATE TABLE Employees (
    EmployeeID INT,
    Name VARCHAR(50) NOT NULL,
    DepartmentID INT,
    Salary DECIMAL(10,2) NOT NULL
);

CREATE TABLE Projects (
    ProjectID INT,
    ProjectName VARCHAR(50) NOT NULL,
    EmployeeID INT
);

INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(101, 'IT'),
(102, 'HR'),
(103, 'Finance'),
(104, 'Marketing');

INSERT INTO Employees (EmployeeID, Name, DepartmentID, Salary) VALUES
(1, 'Alice', 101, 60000),
(2, 'Bob', 102, 70000),
(3, 'Charlie', 101, 65000),
(4, 'David', 103, 72000),
(5, 'Eva', NULL, 68000);

INSERT INTO Projects (ProjectID, ProjectName, EmployeeID) VALUES
(1, 'Alpha', 1),
(2, 'Beta', 2),
(3, 'Gamma', 1),
(4, 'Delta', 4),
(5, 'Omega', NULL);

SELECT * FROM Departments
SELECT * FROM Employees
SELECT * FROM Projects


SELECT e.Name, d.DepartmentName
FROM Employees AS e
INNER JOIN Departments AS d
	ON d.DepartmentID = e.DepartmentID

SELECT e.Name, d.DepartmentName
FROM Employees AS e
LEFT JOIN Departments AS d
	ON d.DepartmentID = e.DepartmentID

SELECT e.Name, d.DepartmentName
FROM Employees AS e
RIGHT JOIN Departments AS d
	ON d.DepartmentID = e.DepartmentID

SELECT e.Name, d.DepartmentName
FROM Employees AS e
FULL JOIN Departments AS d
	ON d.DepartmentID = e.DepartmentID

SELECT 
    d.DepartmentID, 
    d.DepartmentName, 
    SUM(e.Salary) AS TotalSalary
FROM Departments AS d
LEFT JOIN Employees e 
	ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentID, d.DepartmentName;


SELECT *
FROM Employees AS e
CROSS JOIN Departments AS d


SELECT e.Name, d.DepartmentName, p.ProjectName
FROM Employees AS e
LEFT JOIN Departments AS d
	ON d.DepartmentID = e.DepartmentID
LEFT JOIN Projects AS p
	ON p.EmployeeID = e.EmployeeID