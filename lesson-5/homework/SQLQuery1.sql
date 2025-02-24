USE lesson5;
GO

DROP TABLE IF EXISTS Employees;


CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Department VARCHAR(50) NOT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    HireDate DATE NOT NULL
);
GO


INSERT INTO Employees (Name, Department, Salary, HireDate) VALUES
    ('Alice', 'HR', 50000, '2020-06-15'),
    ('Bob', 'HR', 60000, '2018-09-10'),
    ('Charlie', 'IT', 70000, '2019-03-05'),
    ('David', 'IT', 80000, '2021-07-22'),
    ('Eve', 'Finance', 90000, '2017-11-30'),
    ('Frank', 'Finance', 75000, '2019-12-25'),
    ('Grace', 'Marketing', 65000, '2016-05-14'),
    ('Hank', 'Marketing', 72000, '2019-10-08'),
    ('Ivy', 'IT', 67000, '2022-01-12'),
    ('Alice1', 'HR', 50000, '2020-06-15'),
    ('Alisher', 'HR', 67000, '2019-09-10'),
    ('Ahmad', 'IT', 72000, '2019-12-06'),
    ('Doston', 'IT', 91000, '2021-09-23'),
    ('Ali', 'HR', 66000, '2020-06-21');

SELECT * FROM Employees;

SELECT *,
    ROW_NUMBER() OVER(ORDER BY Salary desc) AS SalaryRank
    FROM Employees

SELECT *,
    RANK() OVER(ORDER BY Salary desc) AS SalaryRank
    FROM Employees


SELECT * FROM (
    SELECT *, 
        DENSE_RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS SalaryRank
    FROM Employees
) AS RankedData
WHERE SalaryRank <= 2;


SELECT * 
FROM
    (SELECT *,
    DENSE_RANK() OVER(PARTITION By Department ORDER BY Salary asc) AS SalaryRank
    FROM Employees) as RankedData
WHERE SalaryRank=1


SELECT *,
    SUM(Salary) OVER (PARTITION BY Department ORDER BY Salary ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningSalary
FROM Employees;


SELECT DISTINCT Department,
    SUM(Salary) OVER (PARTITION BY Department) AS TotalSalaryOfDeparment
FROM Employees


SELECT DISTINCT Department, 
    AVG(Salary) OVER (PARTITION BY Department) AS AvgSalaryOfDeparment
FROM Employees


SELECT *,
    AVG(Salary) OVER (PARTITION BY Department) AS AvgSalDep, 
    Salary - AVG(Salary) OVER (PARTITION BY Department) AS SalDiff
FROM Employees


SELECT *,
    AVG(Salary) OVER (ORDER BY HireDate ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS MovingAvgSalary
FROM Employees


SELECT SUM(Salary) AS SalLastHire_3_Emp
FROM (SELECT TOP 3 Salary FROM Employees ORDER BY HireDate DESC) AS LastHired;


SELECT *,
    AVG(salary) OVER(ORDER BY HireDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningAvgSal
FROM Employees


-- Find the Maximum Salary Over a Sliding Window of 2 Employees Before and After
SELECT *,
    Max(salary) OVER(ORDER BY HireDate ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING) AS RunningMaxSal
FROM Employees

-- Determine the Percentage Contribution of Each Employee’s Salary to Their Department’s Total Salary

SELECT *, 
    Cast(Salary / SUM(Salary) OVER(PARTITION BY Department) * 100 AS decimal(10,2)) 
FROM Employees