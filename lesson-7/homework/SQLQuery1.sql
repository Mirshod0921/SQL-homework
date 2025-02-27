use class7

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10,2)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50)
);

-- Insert sample data into Customers table
INSERT INTO Customers (CustomerID, CustomerName) VALUES
(4, 'Alisher Uzoqov'),
(1, 'John Doe'),
(2, 'Jane Smith'),
(3, 'Alice Johnson');

-- Insert sample data into Products table
INSERT INTO Products (ProductID, ProductName, Category) VALUES
(101, 'Laptop', 'Electronics'),
(102, 'Smartphone', 'Electronics'),
(103, 'Tablet', 'Electronics'),
(104, 'Headphones', 'Accessories');

-- Insert sample data into Orders table
INSERT INTO Orders (OrderID, CustomerID, OrderDate) VALUES
(1001, 1, '2024-02-15'),
(1002, 2, '2024-02-16'),
(1003, 1, '2024-02-17'),
(1004, 3, '2024-02-18');

-- Insert sample data into OrderDetails table
INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity, Price) VALUES
(1, 1001, 101, 1, 1200.00),
(2, 1001, 102, 2, 800.00),
(3, 1002, 103, 1, 500.00),
(4, 1003, 104, 3, 150.00),
(5, 1004, 101, 1, 1200.00),
(6, 1004, 102, 1, 800.00);


SELECT c.CustomerName, o.OrderID, o.OrderDate
FROM Customers as c
LEFT JOIN Orders as o
	ON c.CustomerID = o.CustomerID

SELECT c.CustomerID, c.CustomerName
FROM Customers as c
LEFT JOIN Orders as o
	ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL;


SELECT od.OrderID, od.Quantity, p.ProductName
FROM OrderDetails AS od
JOIN Products AS p
	ON od.ProductID = p.ProductID


SELECT c.CustomerName
FROM Customers as c
RIGHT JOIN Orders as o
	ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerName
HAVING COUNT(*) > 1

SELECT 
    od1.OrderID,
    od1.ProductID,
    p.ProductName,
    od1.Price
FROM 
    OrderDetails od1
JOIN 
    Products p ON od1.ProductID = p.ProductID
LEFT JOIN 
    OrderDetails od2 ON od1.OrderID = od2.OrderID AND od1.Price < od2.Price
WHERE 
    od2.OrderDetailID IS NULL;

SELECT 
    o1.CustomerID,
    c.CustomerName,
    o1.OrderID,
    o1.OrderDate
FROM 
    Orders o1
JOIN 
    Customers c ON o1.CustomerID = c.CustomerID
LEFT JOIN 
    Orders o2 ON o1.CustomerID = o2.CustomerID AND o1.OrderDate < o2.OrderDate
WHERE 
    o2.OrderID IS NULL;

SELECT DISTINCT c.CustomerID, c.CustomerName
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY c.CustomerID, c.CustomerName
HAVING COUNT(DISTINCT CASE WHEN p.Category = 'Electronics' THEN p.Category END) = 1
AND COUNT(DISTINCT p.Category) = 1;


SELECT DISTINCT c.CustomerID, c.CustomerName
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
WHERE p.Category = 'Stationery';


SELECT 
    c.CustomerID,
    c.CustomerName,
    SUM(od.Quantity * od.Price) AS TotalSpent
FROM 
    Customers c
JOIN 
    Orders o ON c.CustomerID = o.CustomerID
JOIN 
    OrderDetails od ON o.OrderID = od.OrderID
GROUP BY 
    c.CustomerID, c.CustomerName
ORDER BY 
    TotalSpent DESC;