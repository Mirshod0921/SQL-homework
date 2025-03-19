USE class13
DECLARE @input_date DATE = '2006-08-28'

;WITH cte AS (
    SELECT 
        DATEFROMPARTS(YEAR(@input_date), MONTH(@input_date), 1) AS date,
        DATENAME(weekday, DATEFROMPARTS(YEAR(@input_date), MONTH(@input_date), 1)) AS weekday,
        DATEPART(weekday, DATEFROMPARTS(YEAR(@input_date), MONTH(@input_date), 1)) AS weekdaynum,
        1 as weeknumber
    UNION ALL
    SELECT 
        DATEADD(day, 1, date),
        DATENAME(weekday, DATEADD(day, 1, date)),
        DATEPART(weekday, DATEADD(day, 1, date)),
        CASE
            WHEN DATEPART(weekday, DATEADD(day, 1, date)) > weekdaynum THEN weeknumber
            ELSE weeknumber + 1
        END
    FROM cte
    WHERE date < EOMONTH(date)
)
SELECT
    MAX(CASE WHEN weekday='Sunday' THEN DAY(date) END) AS Sunday,
    MAX(CASE WHEN weekday='Monday' THEN DAY(date) END) AS Monday,
    MAX(CASE WHEN weekday='Tuesday' THEN DAY(date) END) AS Tuesday,
    MAX(CASE WHEN weekday='Wednesday' THEN DAY(date) END) AS Wednesday,
    MAX(CASE WHEN weekday='Thursday' THEN DAY(date) END) AS Thursday,
    MAX(CASE WHEN weekday='Friday' THEN DAY(date) END) AS Friday,
    MAX(CASE WHEN weekday='Saturday' THEN DAY(date) END) AS Saturday
FROM cte
GROUP BY weeknumber;