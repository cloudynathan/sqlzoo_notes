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

-- MEDIUM: 

-- 6. 
SELECT SalesOrderID, UnitPrice 
FROM SalesOrderDetail 
WHERE OrderQty=1

--7. 
SELECT Name, CompanyName 
FROM Customer c, SalesOrderHeader soh, SalesOrderDetail sod, Product p 
WHERE c.CustomerID=soh.CustomerID 
AND soh.SalesOrderID=sod.SalesOrderID 
AND sod.ProductID=p.ProductID 
AND p.Name LIKE '%Racing Socks%';

--8. 
SELECT Description  
FROM Product p, ProductModel pm, ProductModelProductDescription pmpd, ProductDescription pd 
WHERE p.ProductModelID=pm.ProductModelID 
AND pm.ProductModelID=pmpd.ProductModelID 
AND pmpd.ProductDescriptionID=pd.ProductDescriptionID 
AND Culture LIKE '%fr%' 
AND p.ProductID=736;

--9.
SELECT SubTotal, CompanyName, Weight 
FROM Customer c, SalesOrderHeader soh, SalesOrderDetail sod, Product p 
WHERE c.CustomerID=soh.CustomerID 
AND soh.SalesorderID=sod.SalesOrderID 
AND sod.ProductID=p.ProductID 
ORDER BY SubTotal DESC, Weight DESC, CompanyName DESC;

--10.
SELECT SUM(OrderQty)   
FROM Customer c, CustomerAddress ca, Address a, SalesOrderHeader soh, SalesOrderDetail sod, Product p, ProductCategory pc 
WHERE c.CustomerID=ca.CustomerID 
AND ca.AddressID=a.AddressID 
AND c.CustomerID=soh.CustomerID 
AND soh.SalesOrderID=sod.SalesOrderID 
AND sod.ProductID=p.ProductID 
AND p.ProductCategoryID=pc.ProductCategoryID 
AND a.City='London' 
AND p.ProductCategoryID IN (SELECT pc.ProductCategoryID 
                            FROM ProductCategory pc 
                            WHERE Name LIKE '%Cranksets%')


