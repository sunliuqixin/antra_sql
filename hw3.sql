--1.	List all cities that have both Employees and Customers.

SELECT distinct C.City
FROM Employees E JOIN Customers C ON E.City = C.City

SELECT E.FirstName, C.ContactName, E.City, C.City
FROM Employees E JOIN Customers C ON E.City = C.City

--2.	List all cities that have Customers but no Employee.
--	a.	Use sub-query

SELECT DISTINCT C.CITY
FROM Customers C
WHERE C.CITY NOT IN 
(SELECT DISTINCT E.City
FROM Employees E)

--	b.	Do not use sub-query

SELECT DISTINCT C.City
FROM Customers C LEFT JOIN Employees E ON C.City = E.City 
WHERE E.City IS NULL

--3.	List all products and their total order quantities throughout all orders.

SELECT P.ProductName, SUM(OD.Quantity) AS [Total Quantity]
FROM [Order Details] OD JOIN Products P
	ON OD.ProductID = P.ProductID
GROUP BY P.ProductName

--4.	List all Customer Cities and total products ordered by that city.

SELECT C.City,  COUNT(P.ProductID) AS [Total Products]
FROM Customers C JOIN Orders O ON 
	C.CustomerID = O.CustomerID JOIN 
	[Order Details]OD ON O.OrderID = 
	OD.OrderID JOIN Products P ON 
	OD.ProductID = P.ProductID
GROUP BY C.City

--5.	List all Customer Cities that have at least two customers.
--	a.	Use union

SELECT City 
FROM Customers a
GROUP BY City
HAVING COUNT(a.CustomerId) = 2
UNION
SELECT City 
FROM Customers b
GROUP BY City
HAVING COUNT(b.CustomerId) > 2

-- b.	Use sub-query and no union

SELECT B.CITY
FROM
(SELECT A.CITY, COUNT (CustomerID) AS PEOPLE
FROM Customers A
GROUP BY A.CITY) AS B 
WHERE B.PEOPLE >= 2

SELECT City 
FROM Customers b
GROUP BY City
HAVING COUNT(b.CustomerId) >= 2

--6.	List all Customer Cities that have ordered at least two different kinds of products.

SELECT C.City
FROM Customers C JOIN Orders O ON 
	C.CustomerID = O.CustomerID JOIN 
	[Order Details]OD ON O.OrderID = 
	OD.OrderID JOIN Products P ON 
	OD.ProductID = P.ProductID
GROUP BY C.City, P.ProductName
HAVING COUNT(P.ProductID) >= 2

--7.	List all Customers who have ordered products, but have the ‘ship city’ on the order different from their own customer cities.

SELECT DISTINCT C.ContactName
FROM Orders O JOIN Customers C ON O.CustomerID = C.CustomerID
WHERE O.ShipCity != C.City

--8.	List 5 most popular products, their average price, and the customer city that ordered most quantity of it.
--do not know how to do it

WITH MostPopProducts
AS(
SELECT TOP 5 P.ProductName AS [Most Popular Products], P.ProductID
FROM [Order Details] OD JOIN Products P ON P.ProductID = OD.ProductID
GROUP BY P.ProductName, p.ProductID
ORDER BY SUM(OD.Quantity) DESC
)
SELECT M.ProductID, OD2.UnitPrice, City
FROM Orders O JOIN [Order Details] OD2 ON O.OrderID = OD2.OrderID 
		JOIN MostPopProducts M ON OD2.ProductID = M.ProductID 
		JOIN Customers C ON C.CustomerID = O.CustomerID
WHERE M.ProductID = OD2.ProductID
GROUP BY M.ProductID, City, UnitPrice
ORDER BY SUM(OD2.QUANTITY)


--9.	List all cities that have never ordered something but we have employees there.
--		a.	Use sub-query
SELECT E.CITY
FROM Employees E
WHERE E.City NOT IN(
SELECT CITY
FROM Customers
)

--		b.	Do not use sub-query
SELECT E.City
FROM Employees E LEFT JOIN Customers C ON E.City = C.City
WHERE C.City IS NULL

--10.	List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, and also the city of most total quantity of products ordered from. (tip: join  sub-query)



--11. How do you remove the duplicates record of a table?

