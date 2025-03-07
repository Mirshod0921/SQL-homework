use class_testCREATE TABLE Orders (    OrderID INT PRIMARY KEY,    CustomerName VARCHAR(100),    OrderDate DATE);CREATE TABLE OrderDetails (    OrderDetailID INT PRIMARY KEY,    OrderID INT,    ProductName VARCHAR(100),    Quantity INT,    UnitPrice DECIMAL(10,2),    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID));INSERT INTO Orders VALUES     (1, 'Alice', '2024-03-01'),    (2, 'Bob', '2024-03-02'),    (3, 'Charlie', '2024-03-03');INSERT INTO OrderDetails VALUES     (1, 1, 'Laptop', 1, 1000.00),    (2, 1, 'Mouse', 2, 50.00),    (3, 2, 'Phone', 1, 700.00),    (4, 2, 'Charger', 1, 30.00),    (5, 3, 'Tablet', 1, 400.00),    (6, 3, 'Keyboard', 1, 80.00);WITH MaxPrices AS (
    SELECT OrderID, MAX(UnitPrice) AS MaxPrice
    FROM OrderDetails
    GROUP BY OrderID
)
SELECT od.OrderID, o.CustomerName, od.ProductName, od.Quantity, od.UnitPrice
FROM OrderDetails od
JOIN Orders o ON o.OrderID = od.OrderID
JOIN MaxPrices mp ON od.OrderID = mp.OrderID AND od.UnitPrice = mp.MaxPrice;


SELECT o.OrderID, CustomerName,
(
	SELECT max(UnitPrice) as MaxPrice, Quantity, ProductName
	FROM OrderDetails AS od
	WHERE od.OrderID = o.OrderID and od.UnitPrice = max(UnitPrice)
)
FROM Orders AS o





CREATE TABLE TestMax(    Year1 INT    ,Max1 INT    ,Max2 INT    ,Max3 INT);INSERT INTO TestMax VALUES    (2001,10,101,87)    ,(2002,103,19,88)    ,(2003,21,23,89)    ,(2004,27,28,91);SELECT Year1, IIF (Max1>Max2 and Max1>Max3, Max1,IIF (Max2>Max3, Max2, IIF (Max3>Max2, Max3, Max2)))FROM TestMaxSELECT Year1,CASE 	WHEN 