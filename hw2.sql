--2.	Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.
SELECT count(ProductSubcategoryID)
FROM Production.Product

--3.	How many Products reside in each SubCategory? Write a query to display the results with the following titles.
--ProductSubcategoryID CountedProducts

SELECT ProductSubcategoryID, count(ProductSubcategoryID) 
FROM Production.Product
Group by ProductSubcategoryID

--4.	How many products that do not have a product subcategory. 

SELECT count(*)
FROM Production.Product
where ProductSubcategoryID is null

--5.	Write a query to list the sum of products quantity in the Production.ProductInventory table.

select sum(Quantity)
FROM Production.ProductInventory 

--6.	Write a query to list the sum of products in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100.
--		ProductID    TheSum

SELECT ProductID, SUM(Quantity) AS TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY ProductID
HAVING SUM(Quantity) < 100

--7.	Write a query to list the sum of products with the shelf information in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100

SELECT shelf, ProductID, SUM(Quantity) AS TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY shelf, ProductID
HAVING SUM(Quantity) < 100

--8.	Write the query to list the average quantity for products where column LocationID has the value of 10 from the table Production.ProductInventory table.

SELECT AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
WHERE LocationID = 10

--9.	Write query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory
-- ProductID   Shelf      TheAvg

SELECT ProductId, Shelf, AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
GROUP BY ProductID, Shelf

--10.	Write query  to see the average quantity  of  products by shelf excluding rows that has the value of N/A in the column Shelf from the table Production.ProductInventory
--	ProductID   Shelf      TheAvg

SELECT ProductId, Shelf, AVG(Quantity) AS TheAvg
FROM Production.ProductInventory
WHERE Shelf != 'N/A'
GROUP BY ProductID, Shelf

--11.	List the members (rows) and average list price in the Production.Product table. This should be grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null.
--		Color           	Class 	TheCount   	 AvgPrice

SELECT Color, Class, 
		COUNT(*) AS TheCount, 
		ROUND(AVG(ListPrice),2) 
		AS AvgPrice
FROM Production.Product
WHERE NOT(Color IS NULL OR Class IS NULL)
GROUP BY Color, Class

--12.	Write a query that lists the country and province names from person.CountryRegion and person.StateProvince tables. Join them and produce a result set similar to the following. 
--		Country                 Province

SELECT c.Name AS Country, s.Name AS Province
FROM Person.CountryRegion c JOIN Person.StateProvince s 
ON c.CountryRegionCode = s.CountryRegionCode

--13.	Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.
--  Country             Province

SELECT c.Name AS Country, s.Name AS Province
FROM Person.CountryRegion c JOIN Person.StateProvince s 
ON c.CountryRegionCode = s.CountryRegionCode
WHERE c.Name in ('Germany','Canada')

--14.	List all Products that has been sold at least once in last 25 years.

SELECT DISTINCT ProductName
FROM Products p join [Order Details] od 
	 ON p.ProductID = od.ProductID 
	 JOIN Orders o 
	 ON od.OrderID = o.OrderID
WHERE YEAR(GETDATE()) - YEAR(o.OrderDate) <= 25


--15.	List top 5 locations (Zip Code) where the products sold most.

SELECT TOP 5 ShipPostalCode
FROM Orders o JOIN [Order Details] od ON o.OrderID = od.OrderID JOIN Products P ON OD.ProductID = P.ProductID
WHERE O.ShipPostalCode IS NOT NULL
GROUP BY ShipPostalCode
Order BY sum(quantity) DESC


SELECT *
FROM [Order Details]

SELECT *
FROM Orders

--16.	List top 5 locations (Zip Code) where the products sold most in last 25 years.

SELECT TOP 5 ShipPostalCode
FROM Products p JOIN [Order Details] od 
	 ON p.ProductID = od.ProductID 
	 JOIN Orders o 
	 ON od.OrderID = o.OrderID
WHERE YEAR(GETDATE()) - YEAR(o.OrderDate) <= 25
	  AND O.ShipPostalCode IS NOT NULL
GROUP BY ShipPostalCode
Order BY sum(quantity) DESC

--17.	List all city names and number of customers in that city.

SELECT CITY, COUNT(CustomerID) AS NumOfCustomers
FROM Customers
GROUP BY City

SELECT * FROM Customers
WHERE CITY = 'SAO PAULO'


--18.	List city names which have more than 2 customers, and number of customers in that city 

SELECT CITY, COUNT(CustomerID) AS NumOfCustomers
FROM Customers
GROUP BY City
HAVING COUNT(CustomerID) > 2

SELECT * FROM Customers
WHERE CITY = 'SAO PAULO'


--19.	List the names of customers who placed orders after 1/1/98 with order date.

SELECT DISTINCT c.ContactName
FROM Orders o JOIN Customers c ON 
	 o.CustomerID = c.CustomerID
WHERE YEAR(o.OrderDate) >= 1998

--20.	List the names of all customers with most recent order dates 

SELECT c.ContactName, MAX(o.OrderDate)
FROM Orders o JOIN Customers c ON 
	 o.CustomerID = c.CustomerID
GROUP BY c.ContactName

--21.	Display the names of all customers along with the count of products they bought 

SELECT c.ContactName, SUM(Quantity) 
		AS CountOfProducts
FROM [Order Details] od JOIN Orders o 
		ON od.OrderID = o.OrderID JOIN 
		Customers c ON 
		o.CustomerID = c.CustomerID
GROUP BY c.ContactName

--22.	Display the customer ids who bought more than 100 Products with count of products.

SELECT o.CustomerID, SUM(Quantity) 
		AS CountOfProducts
FROM [Order Details] od JOIN Orders o 
		ON od.OrderID = o.OrderID 
GROUP BY o.CustomerID
HAVING SUM(Quantity) > 100


--23.	List all of the possible ways that suppliers can ship their products. Display the results as below
--	Supplier Company Name   	Shipping Company Name

SELECT DISTINCT S.CompanyName 
		AS "Supplier Company Name", 
		SH.CompanyName AS 
		"Shipping Company Name"
FROM Suppliers S JOIN Products P 
	ON S.SupplierID = P.SupplierID JOIN	
	[Order Details] OD ON 
	P.ProductID = OD.ProductID JOIN Orders O 
	ON OD.OrderID = O.OrderID JOIN Shippers SH 
	ON O.ShipVia = SH.ShipperID

--24.	Display the products order each day. Show Order date and Product Name.

SELECT O.OrderDate, P.ProductName
FROM ORDERS O JOIN [Order Details] OD 
	ON O.OrderID = OD.OrderID JOIN 
	Products P ON OD.ProductID = 
	P.ProductID


--25.	Displays pairs of employees who have the same job title.

SELECT A.FirstName, A.LastName, B.FirstName, B.LastName
FROM Employees A JOIN Employees B ON A.Title = B.Title 
WHERE A.FirstName != B.FirstName AND A.LastName != B.LastName 
	AND A.FirstName > B.FirstName

--26.	Display all the Managers who have more than 2 employees reporting to them.

SELECT A.FirstName, A.LastName
FROM Employees A JOIN Employees B
ON A.EmployeeID = B.ReportsTo
GROUP BY A.FirstName, A.LastName
HAVING COUNT (A.FirstName ) > 2

SELECT *
FROM Employees A

--27.	Display the customers and suppliers by city. The results should have the following columns
-- City, Name, Contact Name, Type (Customer or Supplier)

SELECT City, CompanyName, ContactName, 'Supplier' AS Type
FROM Suppliers
UNION
SELECT City, CompanyName, ContactName, 'Customer' AS Type
FROM Customers