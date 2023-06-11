-- The queries provided in this file are original and have been created by me to showcase my advanced SQL skills 
-- using the Project BLU Database. These queries demonstrate the utilization of complex SQL statements such as 
-- RANK, LAG, CASE, among others. PostgreSQL has been employed to develop these queries.

-- Retrieve the month, product name, sales for the month, and sales ranking for the nth best-selling product 
-- for each month in the year 1997.

SELECT *
FROM (
SELECT
EXTRACT(MONTH FROM o.orderdate) AS month,
p.productname,
ROUND(SUM(od.quantity * od.unitprice), 2) AS salesformonth,
RANK() OVER (PARTITION BY EXTRACT(MONTH FROM o.orderdate)
ORDER BY SUM(od.quantity * od.unitprice) DESC) AS salesformonthranking
FROM order_details od
INNER JOIN products p ON od.productid = p.productid
INNER JOIN orders o ON od.orderid = o.orderid
WHERE o.orderdate >= '1997-01-01' AND o.orderdate <= '1997-12-31'
GROUP BY EXTRACT(MONTH FROM o.orderdate), p.productid
) subq
WHERE salesformonthranking = n
ORDER BY month, salesformonthranking, productname


-- RANK OF PRODUCT SALES ALL TIME

SELECT p.productname,
    ROUND(SUM(od.quantity * od.unitprice), 2) AS totalsales,
    RANK() OVER (ORDER BY SUM(od.quantity * od.unitprice) DESC) AS totalsalesrank
FROM order_details od
INNER JOIN products p ON od.productid = p.productid
GROUP BY p.productname

--  Retrieve the company name and the number of orders for all customers who have at 
-- least 3 orders with a discount greater than or equal to 20%.

SELECT *
FROM (
SELECT c.companyname AS CompanyName, COUNT(od.orderid) AS NumOfOrders
FROM order_details od
INNER JOIN orders o ON od.orderid = o.orderid
INNER JOIN customers c ON o.customerid = c.customerid
WHERE od.discount >= 0.20
GROUP BY c.companyname
ORDER BY c.companyname ASC
) subq
WHERE numoforders >= 3
ORDER BY numoforders DESC, CompanyName ASC

-- Retrieve the product name and the number of months ordered in for products that 
-- were ordered in less than 6 unique months within the year.

SELECT *
FROM(
SELECT p.productname AS ProductName,
COUNT(DISTINCT EXTRACT(MONTH FROM o.orderdate)) AS NumMonths
FROM orders o
INNER JOIN order_details od ON o.orderid = od.orderid
INNER JOIN products p ON od.productid = p.productid
WHERE o.orderdate >= '1997-01-01' AND o.orderdate <= '1997-12-31'
GROUP BY p.productname
) subq
WHERE NumMonths < 6
ORDER BY NumMonths ASC, ProductName ASC

-- Create a report that ranks the all-time sales for products based on the first letter 
-- they start with. Include letters that don't have a product starting with them, and 
-- rank them last. Additionally, group all products starting with characters other than 
-- letters as the letter 'OTHER'.

SELECT
CASE WHEN l.lettername IS NULL THEN 'OTHER'
    ELSE l.lettername
    END AS FirstLetter,
ROUND(SUM(od.quantity * od.unitprice), 2) AS TotalSales,
RANK() OVER (ORDER BY SUM(od.quantity * od.unitprice) DESC NULLS LAST) AS SalesRank
FROM order_details od
INNER JOIN products p ON od.productid = p.productid
RIGHT JOIN letters l ON p.letterid = l.letterid
GROUP BY FirstLetter
ORDER BY SalesRank ASC, FirstLetter ASC

-- Retrieve the product ID, product name, and the average quantity per order 
-- (rounded down to the nearest whole number) for all products. 
-- Sort the results from the highest quantity to the lowest quantity.

SELECT
    p.productid AS 'Product ID',
    p.productname AS 'Product Name',
    FLOOR(AVG(od.quantity)) AS 'Avg Quantity Per Order'
FROM order_details od
INNER JOIN products p ON od.productid = p.productid
GROUP BY p.productid, p.productname
ORDER BY FLOOR(AVG(od.quantity)) DESC, p.productid ASC

-- Retrieve the month/year (as a single field), total number of orders, and total 
-- freight for each month between 1997 and 1998, where the total number of orders is 
-- greater than 35. Sort the results by total freight in descending order.

WITH subq AS (
SELECT
    TO_CHAR(o.orderdate, 'Month') || ', ' || EXTRACT(YEAR FROM o.orderdate) AS month_year,
    COUNT(DISTINCT o.orderid) AS numorders,
    ROUND(SUM(o.freight), 2) AS totalfreight
FROM orders o
WHERE EXTRACT(YEAR FROM o.orderdate) BETWEEN '1997' AND '1998'
GROUP BY month_year
)
SELECT *
FROM subq
WHERE numorders > 35
ORDER BY totalfreight DESC

-- The Pricing Team requires a list of products that experienced a unit price increase outside 
-- the range of 20% to 30%. They need the following information for each product: product name, 
-- current unit price (rounded to 2 decimals), previous unit price (rounded to 2 decimals), and 
-- the percentage increase calculated as: (New Number - Original Number) ÷ Original Number × 100 
-- (formatted as an integer, e.g., 50 for 50%). Additionally, the list should only include products 
-- with a total number of orders greater than 10. Finally, the results should be ordered by the 
-- percentage increase in ascending order.

WITH subq AS (
SELECT
od.productid AS productid,
p.productname AS productname,
ROUND(od.unitprice::NUMERIC, 2) AS currentprice,
ROUND(LAG(od.unitprice) OVER (PARTITION BY p.productid ORDER BY o.orderid)::NUMERIC, 2) AS previousprice
FROM products p
INNER JOIN order_details od ON p.productid = od.productid
INNER JOIN orders o ON od.orderid = o.orderid
ORDER BY p.productname ASC, o.orderid ASC
)
SELECT
subq.productname,
subq.currentprice,
subq.previousprice,
ROUND(100 * (subq.currentprice - subq.previousprice) / subq.previousprice) AS percentageincrease,
COUNT(DISTINCT od.orderid) AS numorders
FROM subq
INNER JOIN order_details od ON subq.productid = od.productid
WHERE
subq.currentprice != subq.previousprice
GROUP BY
subq.productname,
subq.currentprice,
subq.previousprice
HAVING
COUNT(DISTINCT od.orderid) > 10
AND ROUND(100 * (subq.currentprice - subq.previousprice) / subq.previousprice) NOT BETWEEN 20 AND 30
ORDER BY
percentageincrease ASC

-- Retrieve a list containing the category name, price category (categorized as below $20, 
-- between $20 and $50, or above $50), total sales in dollars (rounded to the nearest whole number), 
-- and total number of orders for each category. Format the total sales as an integer. 
-- Order the results by category name in ascending order, and within each category, 
-- by price range in ascending order.

SELECT
c.categoryname AS category_name,
CASE
WHEN p.unitprice < 20 THEN '1. Below $20'
WHEN p.unitprice BETWEEN 20 AND 50 THEN '2. $20-$50'
WHEN p.unitprice > 50 THEN '3. Above $50'
END AS price_category,
ROUND(SUM(od.unitprice * od.quantity))::INTEGER AS total_sales,
COUNT(DISTINCT od.orderid) AS total_orders
FROM categories c
LEFT JOIN products p ON c.categoryid = p.categoryid
INNER JOIN order_details od ON p.productid = od.productid
GROUP BY c.categoryname, price_category
ORDER BY category_name ASC, price_category ASC

-- Retrieve a list containing the category name, region category (categorized as North America, 
-- Asia-Pacific, or Europe), total units in stock by region, and total units on order by region. 
-- Order the results by region category in ascending order, and within each region, 
-- by category name in ascending order.

WITH subq AS (
SELECT
CASE
WHEN s.country IN ('USA', 'Brazil', 'Canada') THEN 'North America'
WHEN s.country IN ('Japan', 'Singapore', 'Australia') THEN 'Asia-Pacific'
WHEN s.country IN ('UK', 'Spain', 'Sweden', 'Germany', 'Italy', 'Norway', 'France', 'Denmark', 'Netherlands', 'Finland') THEN 'Europe'
ELSE 'Other'
END AS region_category,
c.categoryname AS category_name
FROM categories c
INNER JOIN products p ON c.categoryid = p.categoryid
INNER JOIN suppliers s ON p.supplierid = s.supplierid
)
SELECT
region_category,
category_name,
SUM(p.unitsinstock) AS total_units_in_stock,
SUM(p.unitsonorder) AS total_units_on_order
FROM subq
INNER JOIN categories c ON subq.category_name = c.categoryname
INNER JOIN products p ON c.categoryid = p.categoryid
GROUP BY category_name, region_category
ORDER BY region_category ASC, category_name ASC

-- Retrieve a list containing the category name, product name, unit price, category average 
-- unit price, category median unit price, unit price against category average rank (below, 
-- equal, or above average), and unit price against category median rank (below, equal, or 
-- above average). The products should not be discontinued. 
-- The results should be ordered by category name in ascending order, and within each category,
-- by product name in ascending order.

WITH avg_prices AS (
SELECT
c.categoryname,
ROUND(AVG(p.unitprice)::NUMERIC, 2) AS avg_cat_price
FROM products p
INNER JOIN categories c ON p.categoryid = c.categoryid
GROUP BY c.categoryname
), med_prices AS (
SELECT
c.categoryname,
ROUND(PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY p.unitprice)::NUMERIC, 2) AS med_cat_price
FROM products p
INNER JOIN categories c ON p.categoryid = c.categoryid
GROUP BY c.categoryname
)
SELECT
c.categoryname,
p.productname,
p.unitprice,
avg.avg_cat_price,
CASE
WHEN p.unitprice < avg.avg_cat_price THEN 'Below Average'
WHEN p.unitprice = avg.avg_cat_price THEN 'Equal Average'
WHEN p.unitprice > avg.avg_cat_price THEN 'Above Average'
END AS avg_price_rank,
med.med_cat_price,
CASE
WHEN p.unitprice < med.med_cat_price THEN 'Below Average'
WHEN p.unitprice = med.med_cat_price THEN 'Equal Average'
WHEN p.unitprice > med.med_cat_price THEN 'Above Average'
END AS med_price_rank
FROM products p
INNER JOIN categories c ON p.categoryid = c.categoryid
INNER JOIN avg_prices avg ON c.categoryname = avg.categoryname
INNER JOIN med_prices med ON c.categoryname = med.categoryname
WHERE p.discontinued = 0
ORDER BY c.categoryname ASC, p.productname ASC

-- For all employees, list: full name (one field), job title, total sales amount (excluding 
-- discount)($), total number of orders, total number of entries (1 entry = 1 row in an order),
-- average amount ($) per order, average amount ($) per entry, total discount amount ($), total 
-- sales amount (including discount) ($), total discount percentage. Requirements/Conditions: round 
-- columns 3,6,7 8,9 to 2 decimal points. Order by: total sales amount (including discount) DESC.

WITH employee_sales AS (
	SELECT
		e.employeeid,
		ROUND(SUM(od.unitprice * od.quantity)::NUMERIC, 2) AS totalsalesnodiscount,
		ROUND(SUM(od.unitprice * od.quantity * od.discount)::NUMERIC, 2) AS totaldiscountamount
	FROM employees e
	INNER JOIN orders o ON e.employeeid = o.employeeid
	INNER JOIN order_details od ON o.orderid = od.orderid
	GROUP BY e.employeeid
)
SELECT
	e.employeeid,
	e.firstname || ' ' || e.lastname AS employeename,
	e.title,
	ROUND(SUM(od.unitprice * od.quantity)::NUMERIC, 2) AS totalsalesnodiscount,
	COUNT(DISTINCT od.orderid) AS numorders,
	COUNT(od.orderid) AS numentries,
	ROUND((SUM(od.unitprice * od.quantity) / COUNT(DISTINCT od.orderid))::NUMERIC, 2) AS avgamountperorder,
	ROUND(AVG(od.unitprice * od.quantity)::NUMERIC, 2) AS avgamountperentry,
	ROUND(es.totaldiscountamount, 2) AS totaldiscountamount,
	ROUND(SUM(od.unitprice * od.quantity * (1 - od.discount))::NUMERIC, 2) AS totalsaleswithdiscount,
	ROUND(((es.totaldiscountamount / es.totalsalesnodiscount) * 100)::NUMERIC, 2) AS totaldiscountpercentage
FROM employees e
INNER JOIN employee_sales es ON e.employeeid = es.employeeid
INNER JOIN orders o ON e.employeeid = o.employeeid
INNER JOIN order_details od ON o.orderid = od.orderid
GROUP BY e.employeeid, es.totaldiscountamount, es.totalsalesnodiscount
ORDER BY totalsaleswithdiscount DESC;


-- List of companies who placed fewer orders in 1997 than they did in 1996, 
-- and how many orders they placed in each of those years:

WITH order_counts AS (
	SELECT
		c.companyname,
		COUNT(*) FILTER (WHERE EXTRACT(YEAR FROM o.orderdate) = 1996) AS numorders1996,
		COUNT(*) FILTER (WHERE EXTRACT(YEAR FROM o.orderdate) = 1997) AS numorders1997
	FROM customers c
	LEFT JOIN orders o ON c.customerid = o.customerid
	GROUP BY c.companyname
)
SELECT *
FROM order_counts
WHERE numorders1996 > numorders1997;


-- What month has had most sales across each year (include total sales amount)?

SELECT
	EXTRACT(YEAR FROM o.orderdate) AS "Year",
	TO_CHAR(o.orderdate, 'Month') AS "Month",
	ROUND(SUM(od.quantity * od.unitprice)::NUMERIC, 2) AS "Total Sales"
FROM order_details od
INNER JOIN orders o ON od.orderid = o.orderid
GROUP BY EXTRACT(YEAR FROM o.orderdate), TO_CHAR(o.orderdate, 'Month')
ORDER BY RANK() OVER (PARTITION BY EXTRACT(YEAR FROM o.orderdate) ORDER BY SUM(od.quantity * od.unitprice) DESC)
LIMIT 3;
