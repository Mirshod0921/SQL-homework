use class8

DROP TABLE IF EXISTS Groupings;

CREATE TABLE Groupings
(
StepNumber  INTEGER PRIMARY KEY,
TestCase    VARCHAR(100) NOT NULL,
[Status]    VARCHAR(100) NOT NULL
);
INSERT INTO Groupings (StepNumber, TestCase, [Status]) 
VALUES
(1,'Test Case 1','Passed'),
(2,'Test Case 2','Passed'),
(3,'Test Case 3','Passed'),
(4,'Test Case 4','Passed'),
(5,'Test Case 5','Failed'),
(6,'Test Case 6','Failed'),
(7,'Test Case 7','Failed'),
(8,'Test Case 8','Failed'),
(9,'Test Case 9','Failed'),
(10,'Test Case 10','Passed'),
(11,'Test Case 11','Passed'),
(12,'Test Case 12','Passed');

-----------------------------------------

DROP TABLE IF EXISTS [dbo].[EMPLOYEES_N];

CREATE TABLE [dbo].[EMPLOYEES_N]
(
    [EMPLOYEE_ID] [int] NOT NULL,
    [FIRST_NAME] [varchar](20) NULL,
    [HIRE_DATE] [date] NOT NULL
)
 
INSERT INTO [dbo].[EMPLOYEES_N]
VALUES
	(1001,'Pawan','1975-02-21'),
	(1002,'Ramesh','1976-02-21'),
	(1003,'Avtaar','1977-02-21'),
	(1004,'Marank','1979-02-21'),
	(1008,'Ganesh','1979-02-21'),
	(1007,'Prem','1980-02-21'),
	(1016,'Qaue','1975-02-21'),
	(1155,'Rahil','1975-02-21'),
	(1102,'Suresh','1975-02-21'),
	(1103,'Tisha','1975-02-21'),
	(1104,'Umesh','1972-02-21'),
	(1024,'Veeru','1975-02-21'),
	(1207,'Wahim','1974-02-21'),
	(1046,'Xhera','1980-02-21'),
	(1025,'Wasil','1975-02-21'),
	(1052,'Xerra','1982-02-21'),
	(1073,'Yash','1983-02-21'),
	(1084,'Zahar','1984-02-21'),
	(1094,'Queen','1985-02-21'),
	(1027,'Ernst','1980-02-21'),
	(1116,'Ashish','1990-02-21'),
	(1225,'Bushan','1997-02-21');

SELECT * FROM Groupings


SELECT 
    MIN(StepNumber) AS MinStepNumber,
    MAX(StepNumber) AS MaxStepNumber,
    Status,
    COUNT(*) AS ConsecutiveCount
FROM (
    SELECT 
        StepNumber,
        Status,
        StepNumber - ROW_NUMBER() OVER (PARTITION BY Status ORDER BY StepNumber) AS grp
    FROM Groupings
) AS Grouped
GROUP BY Status, grp
ORDER BY MinStepNumber;




SELECT 
    MIN(Year_N) AS StartYear, 
    MAX(Year_N) AS EndYear
FROM (
    SELECT 
        Year_N,
        Year_N - ROW_NUMBER() OVER (ORDER BY Year_N) AS grp
    FROM (
        SELECT 1975 + n AS Year_N
        FROM (
            SELECT ordinal AS n FROM STRING_SPLIT(REPLICATE(',', 60), ',', 1)
        ) AS Numbers
        WHERE 1975 + n <= YEAR(GETDATE())
    ) AS AllYears
    LEFT JOIN (SELECT DISTINCT YEAR(HIRE_DATE) AS HireYear FROM EMPLOYEES_N) AS HiredYears
    ON AllYears.Year_N = HiredYears.HireYear
    WHERE HiredYears.HireYear IS NULL
) AS GroupedYears

GROUP BY grp
ORDER BY StartYear;