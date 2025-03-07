use class9
CREATE TABLE Employees
(
	EmployeeID  INTEGER PRIMARY KEY,
	ManagerID   INTEGER NULL,
	JobTitle    VARCHAR(100) NOT NULL
);
INSERT INTO Employees (EmployeeID, ManagerID, JobTitle) 
VALUES
	(1001, NULL, 'President'),
	(2002, 1001, 'Director'),
	(3003, 1001, 'Office Manager'),
	(4004, 2002, 'Engineer'),
	(5005, 2002, 'Engineer'),
	(6006, 2002, 'Engineer');

;WITH cte AS
(
    SELECT *, 0 AS Depth
    FROM employees
    WHERE ManagerID IS NULL
    UNION ALL
    SELECT e.*, Depth + 1
    FROM employees e
    JOIN cte
        ON e.ManagerID = cte.EmployeeID
    
)
SELECT *
FROM cte;

;WITH factorial(Num, Factorial) AS 
(
    SELECT 1, 1
    UNION ALL
    SELECT Num + 1, Factorial * (Num + 1)
    FROM factorial
    WHERE Num < 10
)
SELECT * FROM factorial;

WITH fib(n, Fibonacci_number, Prev) AS 
(
    SELECT 1, 1, 0
    UNION ALL
    SELECT n + 1, Fibonacci_number + Prev, Fibonacci_number
    FROM fib
    WHERE n < 10
)
SELECT n, Fibonacci_number FROM fib;