use class2

CREATE TABLE test_identity (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(50)
);

INSERT INTO test_identity (name) 
VALUES ('Alice'), ('Bob'), ('Adam'), ('John'), ('Doe');

SELECT * FROM test_identity

DELETE FROM test_identity

INSERT INTO test_identity (name) 
VALUES ('Alice');

SELECT * FROM test_identity

-- id, and name columns remain, next id continue where it is remain

INSERT INTO test_identity (name) 
VALUES ('Alice'), ('Bob'), ('Adam'), ('John'), ('Doe');

TRUNCATE TABLE test_identity;
SELECT * FROM test_identity;
INSERT INTO test_identity (name) 
VALUES ('Alice');

SELECT * FROM test_identity;

-- id starts from 1

INSERT INTO test_identity (name) 
VALUES ('Alice'), ('Bob'), ('Adam'), ('John'), ('Doe');

DROP TABLE test_identity;
--no table named test_identity

CREATE TABLE data_types_demo (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(50),
    description TEXT,
    price DECIMAL(10,2),
    quantity SMALLINT,
    created_at DATETIME,
    for_id UNIQUEIDENTIFIER DEFAULT NEWID()
);

INSERT INTO data_types_demo (name, description, price, quantity, created_at, FOR_ID)
VALUES 
('LENOVO', 'Very good laptop', 1500.99, 10, GETDATE(), NEWID())

SELECT * FROM data_types_demo


CREATE TABLE photos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    image_data VARBINARY(MAX)
);

INSERT INTO photos (image_data)
SELECT BulkColumn FROM OPENROWSET(BULK 'C:\Users\LENOVO\Desktop\sql_homework\lesson-2\homework\bird.jpg', SINGLE_BLOB) AS img;

SELECT * FROM photos
SELECT @@SERVERNAME;

CREATE TABLE student (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    classes INT NOT NULL,
    tuition_per_class DECIMAL(10,2) NOT NULL,
    total_tuition AS (classes * tuition_per_class)
);

INSERT INTO student (name, classes, tuition_per_class)
VALUES 
    ('Alice', 5, 200.00),
    ('Bob', 3, 150.00),
    ('John', 4, 180.50);

SELECT * FROM student

CREATE TABLE worker (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

BULK INSERT worker
FROM 'C:\Users\LENOVO\Desktop\sql_homework\lesson-2\homework\workers.csv'
WITH (
	firstrow=2,
	fieldterminator=',',
	rowterminator='\n'
);

SELECT * FROM worker;
