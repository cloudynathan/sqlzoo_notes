-- Adventure Works 

-- EASY: 

-- 1. 
SELECT FirstName, EmailAddress 
FROM Customer c 
WHERE CompanyName='Bike World';

-- 2. 
SELECT CompanyName
FROM Customer c, CustomerAddress ca, Address a 
WHERE c.CustomerID=ca.CustomerID 
AND ca.AddressID=a.AddressID 
AND city='Dallas';

--3. 
SELECT SUM(OrderQty) 
FROM SalesOrderDetail sod, Product p 
WHERE ListPrice > 1000;

-- 4. 
SELECT CompanyName, (SubTotal+TaxAmt+Freight) as Total 
FROM Customer c, SalesOrderHeader soh 
WHERE c.CustomerID=soh.CustomerID AND (SubTotal+TaxAmt+Freight)>100000;

-- 5.
SELECT OrderQty  
FROM Customer c, SalesOrderHeader soh, SalesOrderDetail sod, Product p 
WHERE c.CustomerID=soh.CustomerID 
AND soh.SalesOrderID=sod.SalesOrderID 
AND sod.ProductID=p.ProductID 
AND c.CompanyName='Riding Cycles' AND p.Name='Racing Socks, L'

