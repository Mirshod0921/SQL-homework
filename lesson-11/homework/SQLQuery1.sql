USE class11
DROP TABLE IF EXISTS Employees;
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10,2)
);

INSERT INTO Employees (EmployeeID, Name, Department, Salary)
VALUES
    (1, 'Alice', 'HR', 5000),
    (2, 'Bob', 'IT', 7000),
    (3, 'Charlie', 'Sales', 6000),
    (4, 'David', 'HR', 5500),
    (5, 'Emma', 'IT', 7200);

DROP TABLE IF EXISTS #employeetransfers;
CREATE TABLE #EmployeeTransfers (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10,2)
);

INSERT INTO #EmployeeTransfers
SELECT EmployeeID,
    Name,
    IIF(Department = 'HR', 'IT', 
        IIF(Department = 'IT', 
            'Sales', 
            'HR'
        )
    ) AS Department,
    salary
FROM Employees;


SELECT * FROM #EmployeeTransfers;

---===============================


DROP TABLE IF EXISTS Orders_DB1;
CREATE TABLE Orders_DB1 (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    Product VARCHAR(50),
    Quantity INT
);

INSERT INTO Orders_DB1 VALUES
(101, 'Alice', 'Laptop', 1),
(102, 'Bob', 'Phone', 2),
(103, 'Charlie', 'Tablet', 1),
(104, 'David', 'Monitor', 1);

DROP TABLE IF EXISTS Orders_DB2;
CREATE TABLE Orders_DB2 (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    Product VARCHAR(50),
    Quantity INT
);

INSERT INTO Orders_DB2 VALUES
(101, 'Alice', 'Laptop', 1),
(103, 'Charlie', 'Tablet', 1);


DECLARE @MissingOrders TABLE (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    Product VARCHAR(50),
    Quantity INT
);

INSERT INTO @MissingOrders
SELECT o1.*
FROM Orders_DB1 o1
left join Orders_DB2 o2
    on o1.OrderID = o2.OrderID
WHERE o2.OrderID is NULL;

SELECT * FROM @MissingOrders;


--=========================================

DROP TABLE IF EXISTS WorkLog;
CREATE TABLE WorkLog (
    EmployeeID INT,
    EmployeeName VARCHAR(50),
    Department VARCHAR(50),
    WorkDate DATE,
    HoursWorked INT
);

INSERT INTO WorkLog VALUES
(1, 'Alice', 'HR', '2024-03-01', 8),
(2, 'Bob', 'IT', '2024-03-01', 9),
(3, 'Charlie', 'Sales', '2024-03-02', 7),
(1, 'Alice', 'HR', '2024-03-03', 6),
(2, 'Bob', 'IT', '2024-03-03', 8),
(3, 'Charlie', 'Sales', '2024-03-04', 9);

DROP VIEW IF EXISTS vw_MonthlyWorkSummary;

CREATE VIEW vw_MonthlyWorkSummary AS
SELECT 
    wl1.EmployeeID, 
    wl1.EmployeeName, 
    wl1.Department, 
    SUM(wl1.HoursWorked) AS TotalHoursWorked,
    (SELECT SUM(wl2.HoursWorked) 
     FROM WorkLog wl2 
     WHERE wl2.Department = wl1.Department) AS TotalHoursDepartment,
    (SELECT AVG(wl2.HoursWorked) 
     FROM WorkLog wl2 
     WHERE wl2.Department = wl1.Department) AS AvgHoursDepartment
FROM WorkLog wl1
GROUP BY wl1.EmployeeID, wl1.EmployeeName, wl1.Department;

SELECT * FROM vw_MonthlyWorkSummary