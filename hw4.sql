--4.	Create a view named “view_product_order_[your_last_name]”, list all products and total ordered quantity for that product.

Create VIEW view_product_order_Liu
AS 
SELECT ProductID, SUM(QUANTITY) AS "TotalQuantity"
FROM [Order Details]
GROUP BY ProductID

DROP VIEW view_product_order_Liu

--testing view
select *
from view_product_order_Liu


--5.	Create a stored procedure “sp_product_order_quantity_[your_last_name]” that accept product id as an input and total quantities of order as output parameter.

DROP PROCEDURE IF EXISTS sp_product_order_quantity_Liu

CREATE PROC sp_product_order_quantity_Liu
@p_id INT, 
@total_Quan INT OUT
AS
BEGIN
	SELECT @total_Quan =  SUM(quantity)
	FROM [Order Details]
	WHERE ProductID = @p_id
	GROUP BY ProductID
END

--testing sp_product_order_quantity_Liu
begin
	declare @test int
	exec sp_product_order_quantity_Liu 46, @test out
	PRINT @test
end

--6.	Create a stored procedure “sp_product_order_city_[your_last_name]” that accept product name as an input and top 5 cities that ordered most that product combined with the total quantity of that product ordered from that city as output.
DROP PROCEDURE IF EXISTS sp_product_order_city_Liu

CREATE PROC sp_product_order_city_Liu
@p_name VARCHAR(20),
@city VARCHAR(20) OUTPUT,
@total_quan int OUT
AS
BEGIN
	select top 5 @city =  City, @total_quan = SUM(Quantity)
	from Customers c join Orders o on 
		o.CustomerID=c.CustomerID join 
		[Order Details] od on od.OrderID=o.OrderID 
		join Products p on od.ProductID = p.ProductID
	where p.ProductName = @p_name
	group by city 
	order by SUM(Quantity) desc
END

CREATE PROC sp_product_order_city_Liu_1
@p_name VARCHAR(20),
@t1 table

AS
BEGIN
	select top 5 @city =  City, @total_quan = SUM(Quantity)
	from Customers c join Orders o on 
		o.CustomerID=c.CustomerID join 
		[Order Details] od on od.OrderID=o.OrderID 
		join Products p on od.ProductID = p.ProductID
	where p.ProductName = @p_name
	group by city 
	order by SUM(Quantity) desc
END

--testing sp_product_order_city_Liu
SELECT ProductName FROM Products

BEGIN
	DECLARE @PRODUCT VARCHAR(20)
	--DECLARE @test1 TABLE(product VARCHAR(10) , quantity int)
	DECLARE @CITY1 VARCHAR(100)
	DECLARE @QUANT1 VARCHAR(200)
	SET @PRODUCT = 'CHAI'
	EXEC sp_product_order_city_Liu @PRODUCT, @CITY1, @QUANT1
	PRINT @CITY1
	PRINT @QUANT1
	--create table t1( city varchar(20), quant1 int) 
	--insert into t1 (city, quant1)
	--value (@CITY1 , @QUANT1)
END

--9.	Create 2 new tables “people_your_last_name” “city_your_last_name”. City table has two records: {Id:1, City: Seattle}, {Id:2, City: Green Bay}. People has three records: {id:1, Name: Aaron Rodgers, City: 2}, {id:2, Name: Russell Wilson, City:1}, {Id: 3, Name: Jody Nelson, City:2}. Remove city of Seattle. If there was anyone from Seattle, put them into a new city “Madison”. Create a view “Packers_your_name” lists all people from Green Bay. If any error occurred, no changes should be made to DB. (after test) Drop both tables and view.

--create two tables begin
CREATE TABLE people_Liu(Id INT PRIMARY KEY, Name varchar(20), City INT) --FOREIGN KEY REFERENCES city_Liu(ID))
INSERT INTO people_liu
Values (1, 'Aaron Rodgers', 2), (2, 'Russell Wilson', 1), (3, 'Jody Nelson', 2)

--SELECT * FROM people_Liu


CREATE TABLE city_Liu(Id INT PRIMARY KEY, City varchar(20) NOT NULL)
INSERT INTO city_Liu
VALUES (1, 'SEATTLE'), (2, 'GREEN BAY')

--SELECT * FROM city_Liu

--create two tables end

--modify tables begin

UPDATE city_Liu
SET CITY = 'Madison'
WHERE City = 'Seattle'

SELECT * FROM city_Liu
SELECT * FROM people_Liu

--modify tables end


--create view begin

CREATE VIEW Packers_Qixin_Liu
AS
SELECT P.Id, P.Name
FROM people_Liu P JOIN city_Liu C ON P.City = C.Id
WHERE C.City = 'Green Bay'

SELECT * FROM Packers_Qixin_Liu

--create view end

--dropping tables and view
DROP TABLE people_Liu

DROP TABLE city_Liu

DROP VIEW Packers_Qixin_Liu


--10.	Create a stored procedure “sp_birthday_employees_[you_last_name]” that creates a new table “birthday_employees_your_last_name” and fill it with all employees that have a birthday on Feb. (Make a screen shot) drop the table. Employee table should not be affected.

CREATE PROC sp_birthday_employees_Liu
AS
begin
SELECT *
INTO birthday_employees_Liu
FROM Employees e
WHERE MONTH(e.BirthDate) = 2
END
EXEC sp_birthday_employees_Liu

DROP TABLE birthday_employees_Liu

select * from birthday_employees_Liu


--11.	Create a stored procedure named “sp_your_last_name_1” that returns all cites that have at least 2 customers who have bought no or only one kind of product. Create a stored procedure named “sp_your_last_name_2” that returns the same but using a different approach. (sub-query and no-sub-query).

CREATE PROC sp_Liu_1
AS
BEGIN
SELECT C2.City
FROM CUSTOMERS C2
WHERE C2.CUSTOMERID IN (SELECT C1.CustomerID
	FROM CUSTOMERS C1 JOIN Orders O ON C1.CustomerID = O.CustomerID JOIN [Order Details] OD ON O.OrderID = OD.OrderID
	GROUP BY C1.City, C1.CustomerID
	HAVING COUNT(OD.ProductID) <= 1)
GROUP BY C2.CustomerID, C2.City
HAVING COUNT(CUSTOMERID) >= 2
END

CREATE PROC sp_Liu_2
AS
BEGIN
SELECT City
FROM Customers
GROUP BY City
HAVING COUNT(CUSTOMERID) >=2

INTERSECT

SELECT C3.CITY
FROM CUSTOMERS C3 JOIN Orders O1 ON C3.CustomerID = O1.CustomerID JOIN [Order Details] OD1 ON O1.OrderID = OD1.OrderID
GROUP BY C3.City, C3.CustomerID
HAVING COUNT(OD1.ProductID) <= 1
END




