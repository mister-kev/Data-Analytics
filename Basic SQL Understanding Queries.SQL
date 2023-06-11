-- I have included my solutions to 50 different practice queries on the PROJECT BLU Database, which were obtained 
-- from an online PDF file, in this document. These queries were specifically designed to demonstrate a basic understanding 
-- of SQL queries and related functions, and they were implemented using PostgreSQL.

/* 50 Practice Queries of PROJECT BLU Database */

-- 1. Generate a report displaying the names and descriptions of categories from the category table, 
-- sorted alphabetically by category name.

SELECT c.categoryname, c.description 
FROM categories c
ORDER BY c.categoryname ASC

-- 2. Create a report showing the names, company names, job titles, and phone numbers of customers from the 
-- customer table, sorted in ascending order by phone number.

SELECT c.contactname, c.companyname, c.contacttitle, c.phone
FROM customers c
ORDER BY c.phone ASC

-- 3. Generate a report that presents the first names and last names of employees, with each name capitalized 
-- and renamed as "FirstName" and "LastName" respectively. Also, include the hire date and sort the results 
-- from the newest to the oldest employee.

SELECT INITCAP(e.firstname) "FirstName", INITCAP(e.lastname) "LastName", e.hiredate
FROM employees e
ORDER BY e.hiredate ASC

-- 4. Create a report showing the top 10 order IDs, order dates, shipped dates, customer IDs, 
-- and freight values from the orders table, sorted in descending order by freight

SELECT o.orderid, o.orderdate, o.shippeddate, o.customerid, o.freight
FROM orders o
ORDER BY freight DESC
LIMIT 10

-- 5. Generate a report displaying all customer IDs in lowercase letters, 
-- renamed as "ID," from the customers table.

SELECT LOWER(c.customerid) "ID"
FROM customers c

-- 6. Create a report that presents the company names, fax numbers, phone numbers, 
-- countries, and homepages from the suppliers table, sorted in descending order by 
-- country and then in ascending order by company name.

SELECT s.companyname, s.fax, s.phone, s.country, s.homepage
FROM suppliers s
ORDER BY s.country DESC, s.companyname ASC

-- 7. Generate a report showing the company names and contact names of customers located only in 'Buenos Aires.'

SELECT c.companyname, c.contactname
FROM customers c
WHERE c.city = 'Buenos Aires'

-- 8. Create a report that displays the product names, unit prices, 
-- and quantity per unit of products that are currently out of stock.

SELECT p.productname, p.unitprice, p.quantityperunit
FROM products p
WHERE p.discontinued = 1

-- 9. Generate a report showing the contact names, addresses, and cities of customers who are not from Germany, 
-- Mexico, or Spain.

SELECT c.contactname, c.address, c.city
FROM customers c
WHERE c.country NOT IN ('Germany', 'Mexico', 'Spain')

-- 10. Create a report displaying the order dates, shipped dates, customer IDs, and 
-- freight values of all orders placed on May 21, 1997.

SELECT o.orderdate, o.shippeddate, o.customerid, o.freight
FROM orders o
WHERE o.orderdate = '1997-05-21'

-- 11. Generate a report displaying the first name, last name, and country of employees who are not from the 
-- United States.

SELECT e.firstname, e.lastname, e.country
FROM employees e
WHERE e.country != 'USA'

-- 12. Create a report showing the employee ID, order ID, customer ID, required date, 
-- shipped date from orders where the shipped date is later than the required date.

SELECT o.employeeid, o.orderid, o.customerid, o.requireddate, o.shippeddate
FROM orders o
WHERE o.shippeddate > o.requireddate

-- 13. Generate a report showing the city, company name, and contact name of 
-- customers from cities that start with the letter 'A' or 'B'.

SELECT c.city, c.companyname, c.contactname    -- DOES WORK
FROM customers c
WHERE c.city LIKE 'A%' OR c.city LIKE 'B%'

SELECT c.city, c.companyname, c.contactname    -- DOES WORK
FROM customers c
WHERE c.city ILIKE ANY('{a%,b%}')

SELECT c.city, c.companyname, c.contactname    -- DOESN'T WORK BUT SHOULD
FROM customers c
WHERE c.city LIKE '[AB]%'

-- 14. Create a report displaying all even numbers for order IDs from the orders table.

SELECT o.orderid 
FROM orders o
WHERE MOD(o.orderid,2) = 0

-- 15. Generate a report showing all orders where the freight cost is greater than $500.

SELECT * 
FROM orders o
WHERE o.freight > 500

-- 16. Create a report showing the product name, units in stock, units on order, 
-- and reorder level of products that need to be reordered.

SELECT p.productname, p.unitsinstock, p.unitsonorder, p.reorderlevel
FROM products p
WHERE p.unitsinstock + p.unitsonorder < p.reorderlevel

-- 17. Generate a report showing the company name, contact name, and phone number 
-- of customers who do not have a fax number.

SELECT c.companyname, c.contactname, c.phone
FROM customers c
WHERE c.fax IS NULL

-- 18. Create a report showing the first name and last name of employees who do not report to anyone.

SELECT e.firstname, e.lastname 
FROM employees e
WHERE e.reportsto IS NULL

-- 19. Generate a report displaying all odd numbers for order IDs from the orders table.

SELECT o.orderid
FROM orders o
WHERE MOD(o.orderid,2) != 0

-- 20. Create a report showing the company name, contact name, and fax number of customers 
-- who do not have a fax number, sorted by contact name.

SELECT c.companyname, c.contactname, c.fax
FROM customers c
WHERE c.fax IS NULL 
ORDER BY c.contactname ASC

-- 21. Generate a report showing the city, company name, and contact name of customers from 
-- cities that contain the letter 'L' in the name, sorted by contact name.

SELECT c.city, c.companyname, c.contactname
FROM customers c
WHERE c.city LIKE '%l%'
ORDER BY c.contactname

-- 22. Create a report showing the first name, last name, and birth date of employees born in the 1950s.

SELECT e.firstname, e.lastname, e.birthdate
FROM employees e
WHERE EXTRACT(YEAR FROM e.birthdate) BETWEEN 1950 AND 1959

-- 23. Generate a report showing the first name, last name, and birth year (extracted from the birth date) of employees.

SELECT e.firstname, e.lastname, EXTRACT(YEAR FROM e.birthdate) birthyear
FROM employees e

-- 24. Create a report showing the order ID and the total number of order IDs as "NumberofProducts" from the order details 
-- table. Group the results by order ID and sort them in descending order by the number of products.

SELECT od.orderid, COUNT(od.productid) NumberOfProducts
FROM order_details od
GROUP BY od.orderid
ORDER BY NumberOfProducts DESC

-- 25. Generate a report showing the supplier ID, product name, and company name of products supplied by "Exotic Liquids," 
-- "Specialty Biscuits, Ltd.," and "Escargots Nouveaux." Sort the results by the supplier ID.

SELECT p.supplierid, p.productname, s.companyname
FROM products p
INNER JOIN suppliers s ON p.supplierid = s.supplierid
WHERE p.supplierid IN (1,8,27)
ORDER BY p.supplierid ASC

-- 26. Create a report showing the ship postal code, order ID, order date, required date, shipped date, 
-- and ship address of all orders with ship postal codes starting with "98124."

SELECT o.shippostalcode, o.orderid, o.orderdate, o.requireddate, o.shippeddate, 
	o.shipaddress
FROM orders o
WHERE o.shippostalcode LIKE '98124%'

-- 27. Generate a report showing the contact name, contact title, and company name of customers 
-- who do not have the word "Sales" in their contact title.

SELECT c.contactname, c.contacttitle, c.companyname
FROM customers c
WHERE c.contacttitle NOT ILIKE '%Sales%'

-- 28. Create a report showing the last name, first name, and city of employees who are located 
-- in cities other than "Seattle."

SELECT e.lastname, e.firstname, e.city
FROM employees e
WHERE NOT city = 'Seattle'

-- 29. Generate a report showing the company name, contact title, city, and country of customers 
-- located in any city in Mexico or any city in Spain other than Madrid.

SELECT c.companyname, c.contacttitle, c.city, c.country
FROM customers c
WHERE c.country IN ('Mexico', 'Spain') AND c.city != 'Madrid'
--WHERE (c.county = 'Mexico') OR (c.country = 'Spain' AND c.city != 'Madrid)

-- 30. Create a SELECT statement that outputs the following: 
-- "contact name can be reached at phone" with the column name "Contactinfo."

SELECT s.contactname || ' can be reached at ' || s.phone AS "Contactinfo"
FROM suppliers s

-- 31. Generate a report showing the contact name of all customers whose names do not 
-- have the letter "A" as the second letter.

SELECT c.contactname
FROM customers c
WHERE c.contactname NOT ILIKE '_a%'

-- 32. Create a report showing the average unit price rounded up to the next whole number, 
-- the total price of units in stock rounded to two decimal points, and the highest number 
-- of orders from the products table. Save them as "AveragePrice," "TotalStock," and "TotalNumberOrdered," respectively.

SELECT CEILING(AVG(p.unitprice)) AS AveragePrice,
       ROUND(SUM(p.unitprice * p.unitsinstock), 2) AS TotalStock,
       MAX((SELECT COUNT(*) FROM order_details WHERE productid = p.productid)) AS TotalNumberOrdered
FROM products p

-- 33. Create a report showing the product ID, product name, company name, category name, description, quantity per unit, 
-- unit price, units in stock, units on order, reorder level, and discontinued status from the products, suppliers, 
-- and categories tables.

SELECT p.productid, p.productname, s.companyname, c.categoryname, c.description, p.quantityperunit,
       p.unitprice, p.unitsinstock, p.unitsonorder, p.reorderlevel, p.discontinued
FROM products p
JOIN suppliers s ON p.supplierid = s.supplierid
JOIN categories c ON p.categoryid = c.categoryid


-- 34. Create a report showing the company name and the sum of freight from the orders table. Group the results by
-- company name and only include companies with a sum of freight greater than $200. Sort the results in descending 
-- order by the sum of freight.

SELECT c.companyname, SUM(o.freight)
FROM orders o
INNER JOIN customers c ON o.customerid = c.customerid
GROUP BY c.companyname
HAVING SUM(o.freight) > 200
ORDER BY SUM(o.freight) DESC

-- 35. Generate a report showing the order ID, contact name, total price, total quantity, 
-- and discount for every order that had a discount given.

SELECT od.orderid, c.contactname,
       ROUND(SUM(od.unitprice * od.quantity) * (1 - od.discount), 2) AS totalprice,
       SUM(od.quantity) AS totalquantity, od.discount
FROM order_details od
JOIN orders o ON od.orderid = o.orderid
JOIN customers c ON o.customerid = c.customerid
WHERE od.discount > 0
GROUP BY od.orderid, c.contactname, od.discount

-- 36. Create a report showing the employee ID, employee name, and manager name 
-- (the name of the person they report to) from the employees table. Sort the results by employee ID.

SELECT e.employeeid, CONCAT(e.firstname, ' ', e.lastname) AS employeename,
       CONCAT(m.firstname, ' ', m.lastname) AS managername
FROM employees e
LEFT JOIN employees m ON e.reportsto = m.employeeid
ORDER BY e.employeeid

-- 37. Generate a report showing the average unit price rounded to two decimal places, 
-- the minimum unit price, and the maximum unit price from the products table.

SELECT ROUND(AVG(unitprice), 2) AS averageprice, MIN(unitprice) AS minimumprice, MAX(unitprice) AS maximumprice
FROM products

-- 38. Create a view named "Order-CustomerInfo" that shows the order ID, customer ID, company name, 
-- contact name, contact title, address, city, country, phone, order date, required date, and shipped 
-- date from the customers and orders tables.

CREATE VIEW "Order-CustomerInfo" AS
SELECT o.orderid, o.customerid, c.companyname, c.contactname, c.contacttitle,
       c.address, c.city, c.country, c.phone, o.orderdate, o.requireddate, o.shippeddate
FROM orders o
JOIN customers c ON o.customerid = c.customerid

-- 39. Change the name of the view "Order-CustomerInfo" to "Order-CustomerDetails."

ALTER VIEW "Order-CustomerInfo" RENAME TO "Order-CustomerDetails"


-- 40. Create a view named "ProductDetails" that shows the product ID, product name, 
-- company name, category name, description, quantity per unit, unit price, units in stock, 
-- units on order, reorder level, and discontinued status from the products, suppliers, and categories tables.

CREATE VIEW "ProductDetails" AS
SELECT p.productid, p.productname, s.companyname, c.categoryname, c.description,
       p.quantityperunit, p.unitprice, p.unitsinstock, p.unitsonorder, p.reorderlevel, p.discontinued
FROM products p
JOIN suppliers s ON p.supplierid = s.supplierid
JOIN categories c ON p.categoryid = c.categoryid

-- 41. Drop the view "Order-CustomerDetails".

DROP VIEW IF EXISTS "Order-CustomerDetails";

-- 42. Create a report that fetches the first 5 characters of the category name from the categories 
-- table and renames it as "ShortInfo".

SELECT c.categoryname, LEFT(c.categoryname,5) ShortInfo
FROM categories c

-- 43. Create a copy of the "shippers" table named "shippers_duplicate" 
-- and insert a copy of the data from the "shippers" table into the new table.

CREATE TABLE shippers_duplicate AS SELECT * FROM shippers;

-- 44. Create a report that shows the product name and company name from all products in the "Seafood" category.

SELECT p.productname, s.companyname
FROM products p
JOIN suppliers s ON p.supplierid = s.supplierid
JOIN categories c ON p.categoryid = c.categoryid
WHERE c.categoryname = 'Seafood';

-- 45. Create a report that shows the category ID, company name, and product name from all products in category ID 5.

SELECT c.categoryid, s.companyname, p.productname
FROM products p
JOIN suppliers s ON p.supplierid = s.supplierid
JOIN categories c ON p.categoryid = c.categoryid
WHERE c.categoryid = 5;


-- 46. Delete the shippers_duplicate table.

DROP TABLE IF EXISTS shippers_duplicate;

-- 47. Create a SELECT statement that outputs the full name, title, and age of all employees.

SELECT CONCAT(firstname, ' ', lastname) AS fullname, title,
       DATE_PART('year', AGE(CURRENT_DATE, birthdate)) AS age
FROM employees;

-- 48. Create a report that shows the company name and the total number of orders by customer, 
-- renamed as "number of orders," since December 31, 1994. Only include customers with more 
-- than 10 orders and sort the results in descending order by the number of orders.

SELECT c.companyname, COUNT(o.orderid) AS "number of orders"
FROM orders o
JOIN customers c ON o.customerid = c.customerid
WHERE o.orderdate > '1994-12-31'
GROUP BY c.companyname
HAVING COUNT(o.orderid) > 10
ORDER BY COUNT(o.orderid) DESC;


-- 49. Create a SELECT statement that outputs the following from the "products" table: product ID, 
-- a string combining the product name, "weighs/is," the quantity per unit, "and costs $," 
-- and the unit price, as "ProductInfo."

SELECT p.productid, p.productname || ' weighs/is ' || p.quantityperunit || 
	' and costs $' || p.unitprice "ProductInfo"
FROM products p

-- 50. Create a report that shows the top 5 customers with the highest total order values. 
-- Include the customer ID, company name, and the sum of order values. 
-- Sort the results in descending order by the total order value.

SELECT o.customerid, c.companyname, SUM(od.quantity * od.unitprice) AS total_order_value
FROM orders o
JOIN order_details od ON o.orderid = od.orderid
JOIN customers c ON o.customerid = c.customerid
GROUP BY o.customerid, c.companyname
ORDER BY total_order_value DESC
LIMIT 5;
