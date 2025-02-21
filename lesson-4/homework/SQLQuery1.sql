use class4
CREATE TABLE [dbo].[TestMultipleZero]
(
    [A] [int] NULL,
    [B] [int] NULL,
    [C] [int] NULL,
    [D] [int] NULL
);
GO

INSERT INTO [dbo].[TestMultipleZero](A,B,C,D)
VALUES 
    (0,0,0,1),
    (0,0,1,0),
    (0,1,0,0),
    (1,0,0,0),
    (0,0,0,0),
    (1,1,1,0);

SELECT * FROM TestMultipleZero
WHERE A+B+C+D>0

CREATE TABLE TestMax
(
    Year1 INT
    ,Max1 INT
    ,Max2 INT
    ,Max3 INT
);
GO
 
INSERT INTO TestMax 
VALUES
    (2001,10,101,87)
    ,(2002,103,19,88)
    ,(2003,21,23,89)
    ,(2004,27,28,91);

SELECT Year1, 
    IIF(Max1 >= Max2 and Max1 >= Max3, Max1, IIF(Max2 >= Max3, Max2, Max3)) as MaxAll
FROM TestMax;


CREATE TABLE EmpBirth
(
    EmpId INT IDENTITY(1,1),
	EmpName VARCHAR(50),
	BirthDate DATETIME 
);
 
INSERT INTO EmpBirth(EmpName,BirthDate)
SELECT 'Pawan' , '12/04/1983'
UNION ALL
SELECT 'Zuzu' , '11/28/1986'
UNION ALL
SELECT 'Parveen', '05/07/1977'
UNION ALL
SELECT 'Mahesh', '01/13/1983'
UNION ALL
SELECT'Ramesh', '05/09/1983';

SELECT * FROM EmpBirth
WHERE MONTH(BirthDate) = 5 and DAY(BirthDate) >= 7 and DAY(BirthDate) <= 15;



CREATE TABLE letters
(letter CHAR(1));

INSERT INTO letters
VALUES ('a'), ('a'), ('a'), 
  ('b'), ('c'), ('d'), ('e'), ('f');

SELECT *
FROM letters
ORDER BY 
    CASE
        WHEN letter = 'b' THEN 1
        ELSE 2
    END,
letter;

SELECT * FROM letters
ORDER BY
    CASE 
        WHEN letter = 'b' THEN 2
        ELSE 1
    END,
letter;

