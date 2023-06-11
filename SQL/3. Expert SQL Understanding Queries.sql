-- Using the same Project BLU Database, I've designed 10 much more complex questions and provided solutions.

-- 1. Retrieve the top 3 customers who have made the highest total purchases in each category, 
-- considering only the customers who have placed orders in all years from 1996 to 2000. 
-- Include the category name, customer ID, and total purchase amount. Order the results 
-- by category name and total purchase amount in descending order.

WITH customer_totals AS (
    SELECT c.customerid, p.categoryid, SUM(od.unitprice * od.quantity) AS total_purchase
    FROM customers c
    JOIN orders o ON c.customerid = o.customerid
    JOIN order_details od ON o.orderid = od.orderid
    JOIN products p ON od.productid = p.productid
    WHERE DATE_PART('year', o.orderdate) BETWEEN 1996 AND 2000
    GROUP BY c.customerid, p.categoryid
),
category_ranks AS (
    SELECT categoryid, customerid, total_purchase,
        ROW_NUMBER() OVER (PARTITION BY categoryid ORDER BY total_purchase DESC) AS rank
    FROM customer_totals
    WHERE customerid IN (
        SELECT customerid
        FROM orders
        WHERE DATE_PART('year', orderdate) BETWEEN 1996 AND 2000
        GROUP BY customerid
        HAVING COUNT(DISTINCT DATE_PART('year', orderdate)) = 5
    )
)
SELECT c.categoryname, cr.customerid, cr.total_purchase
FROM category_ranks cr
JOIN categories c ON cr.categoryid = c.categoryid
WHERE cr.rank <= 3
ORDER BY c.categoryname, cr.total_purchase DESC;

-- 2. Calculate the retention rate of customers from year to year, considering customers who have 
-- placed at least one order in consecutive years. Display the retention rate for each year pair 
-- in descending order by the first year.

WITH customer_years AS (
    SELECT customerid, DATE_PART('year', orderdate) AS order_year
    FROM orders
    GROUP BY customerid, DATE_PART('year', orderdate)
),
retention_rates AS (
    SELECT 
        c1.order_year AS year1, 
        c2.order_year AS year2,
        COUNT(DISTINCT c1.customerid) AS num_customers_year1,
        COUNT(DISTINCT c2.customerid) AS num_customers_year2,
        COUNT(DISTINCT CASE WHEN c1.customerid = c2.customerid THEN c1.customerid END) AS retained_customers
    FROM customer_years c1
    JOIN customer_years c2 ON c1.customerid = c2.customerid
    WHERE c2.order_year = c1.order_year + 1
    GROUP BY c1.order_year, c2.order_year
)
SELECT year1, year2, 
    ROUND((retained_customers::numeric / num_customers_year1) * 100, 2) AS retention_rate
FROM retention_rates
ORDER BY year1 DESC;

-- 3. Determine the top-selling product for each year based on the highest total sales amount, 
-- including the product name and the year. If there is a tie in sales amount, consider the 
-- product with the highest number of orders. If there is still a tie, consider the product 
-- with the lowest product ID.

WITH product_sales AS (
    SELECT 
        p.productname,
        DATE_PART('year', o.orderdate) AS year,
        SUM(od.unitprice * od.quantity) AS total_sales,
        COUNT(DISTINCT od.orderid) AS num_orders,
        ROW_NUMBER() OVER (PARTITION BY DATE_PART('year', o.orderdate) ORDER BY SUM(od.unitprice * od.quantity) DESC, COUNT(DISTINCT od.orderid) DESC, p.productid ASC) AS rn
    FROM products p
    JOIN order_details od ON p.productid = od.productid
    JOIN orders o ON od.orderid = o.orderid
    GROUP BY p.productid, p.productname, DATE_PART('year', o.orderdate)
)
SELECT productname, year, total_sales
FROM product_sales
WHERE rn = 1
ORDER BY year ASC;

-- 4. Retrieve the top 5 customers with the highest average order amount per year, considering only 
-- customers who have placed orders in all years from 2015 to 2020. Include the customer ID, 
-- average order amount, and the year. Order the results by the average order amount in descending order.

WITH customer_avg_orders AS (
    SELECT 
        c.customerid, 
        DATE_PART('year', o.orderdate) AS order_year,
        AVG(od.unitprice * od.quantity) AS avg_order_amount
    FROM customers c
    JOIN orders o ON c.customerid = o.customerid
    JOIN order_details od ON o.orderid = od.orderid
    WHERE DATE_PART('year', o.orderdate) BETWEEN 2015 AND 2020
    GROUP BY c.customerid, DATE_PART('year', o.orderdate)
),
customer_ranks AS (
    SELECT customerid, order_year, avg_order_amount,
        ROW_NUMBER() OVER (PARTITION BY order_year ORDER BY avg_order_amount DESC) AS rank
    FROM customer_avg_orders
    WHERE customerid IN (
        SELECT customerid
        FROM orders
        WHERE DATE_PART('year', orderdate) BETWEEN 2015 AND 2020
        GROUP BY customerid
        HAVING COUNT(DISTINCT DATE_PART('year', orderdate)) = 6
    )
)
SELECT cr.customerid, cr.avg_order_amount, cr.order_year
FROM customer_ranks cr
WHERE cr.rank <= 5
ORDER BY cr.avg_order_amount DESC;

-- 5. Calculate the monthly order growth rate for each category, comparing the number of orders 
-- in the current month with the number of orders in the previous month. Display the category name, 
-- current month, previous month, and the growth rate in percentage. Order the results by category 
-- name and current month.

WITH monthly_orders AS (
    SELECT 
        c.categoryname,
        DATE_TRUNC('month', o.orderdate) AS month,
        COUNT(DISTINCT o.orderid) AS num_orders,
        ROW_NUMBER() OVER (PARTITION BY c.categoryname ORDER BY DATE_TRUNC('month', o.orderdate)) AS rn
    FROM categories c
    JOIN products p ON c.categoryid = p.categoryid
    JOIN order_details od ON p.productid = od.productid
    JOIN orders o ON od.orderid = o.orderid
    GROUP BY c.categoryname, DATE_TRUNC('month', o.orderdate)
)
SELECT 
    mo1.categoryname,
    TO_CHAR(mo2.month, 'Mon YYYY') AS current_month,
    TO_CHAR(mo1.month, 'Mon YYYY') AS previous_month,
    ROUND(((mo2.num_orders - mo1.num_orders) / mo1.num_orders::numeric) * 100, 2) AS growth_rate
FROM monthly_orders mo1
JOIN monthly_orders mo2 ON mo1.categoryname = mo2.categoryname AND mo1.rn + 1 = mo2.rn
ORDER BY mo1.categoryname, mo2.month;

-- 6. Retrieve the top 3 customers who have made the highest total purchases in each category, considering only 
-- the customers who have placed orders in all years from 2010 to 2022. 
-- Include the category name, customer ID, and total purchase amount. 
-- Order the results by category name and total purchase amount in descending order.

WITH customer_totals AS (
    SELECT c.customerid, p.categoryid, SUM(od.unitprice * od.quantity) AS total_purchase
    FROM customers c
    JOIN orders o ON c.customerid = o.customerid
    JOIN order_details od ON o.orderid = od.orderid
    JOIN products p ON od.productid = p.productid
    WHERE DATE_PART('year', o.orderdate) BETWEEN 2010 AND 2022
    GROUP BY c.customerid, p.categoryid
),
category_ranks AS (
    SELECT categoryid, customerid, total_purchase,
        ROW_NUMBER() OVER (PARTITION BY categoryid ORDER BY total_purchase DESC) AS rank
    FROM customer_totals
    WHERE customerid IN (
        SELECT customerid
        FROM orders
        WHERE DATE_PART('year', orderdate) BETWEEN 2010 AND 2022
        GROUP BY customerid
        HAVING COUNT(DISTINCT DATE_PART('year', orderdate)) = 13
    )
)
SELECT c.categoryname, cr.customerid, cr.total_purchase
FROM category_ranks cr
JOIN categories c ON cr.categoryid = c.categoryid
WHERE cr.rank <= 3
ORDER BY c.categoryname, cr.total_purchase DESC;

-- 7. Calculate the customer churn rate for each year, considering customers who have placed 
-- orders in the previous year but not in the current year. 
-- Display the churn rate for each year in descending order.

WITH customer_years AS (
    SELECT customerid, DATE_PART('year', orderdate) AS order_year
    FROM orders
    GROUP BY customerid, DATE_PART('year', orderdate)
),
churn_rates AS (
    SELECT 
        order_year - 1 AS prev_year,
        order_year AS curr_year,
        COUNT(DISTINCT CASE WHEN order_year = curr_year - 1 THEN customerid END) AS num_customers_prev_year,
        COUNT(DISTINCT CASE WHEN order_year = curr_year THEN customerid END) AS num_customers_curr_year,
        COUNT(DISTINCT CASE WHEN order_year = curr_year - 1 AND curr_year IS NOT NULL THEN customerid END) AS churned_customers
    FROM customer_years
    GROUP BY order_year
)
SELECT curr_year, churned_customers::numeric / num_customers_prev_year * 100 AS churn_rate
FROM churn_rates
ORDER BY curr_year DESC;

-- 8. Determine the top-selling product for each year based on the highest total sales amount, 
-- excluding any products that were discontinued. Include the product name and the year. 
-- If there is a tie in sales amount, consider the product with the highest number of orders. 
-- If there is still a tie, consider the product with the lowest product ID.

WITH product_sales AS (
    SELECT 
        p.productname,
        DATE_PART('year', o.orderdate) AS year,
        SUM(od.unitprice * od.quantity) AS total_sales,
        COUNT(DISTINCT od.orderid) AS num_orders,
        ROW_NUMBER() OVER (PARTITION BY DATE_PART('year', o.orderdate) ORDER BY SUM(od.unitprice * od.quantity) DESC, COUNT(DISTINCT od.orderid) DESC, p.productid) AS rn
    FROM products p
    JOIN order_details od ON p.productid = od.productid
    JOIN orders o ON od.orderid = o.orderid
    WHERE p.discontinued = 0
    GROUP BY p.productid, p.productname, DATE_PART('year', o.orderdate)
)
SELECT productname, year
FROM product_sales
WHERE rn = 1
ORDER BY year ASC;

-- 9. Retrieve the top 5 customers with the highest average order amount per year, considering only customers who have placed 
-- orders in all years from 2015 to 2020. Include the customer ID, average order amount, and the year. 
-- Order the results by the average order amount in descending order.

WITH customer_avg_orders AS (
    SELECT 
        c.customerid, 
        DATE_PART('year', o.orderdate) AS order_year,
        AVG(od.unitprice * od.quantity) AS avg_order_amount
    FROM customers c
    JOIN orders o ON c.customerid = o.customerid
    JOIN order_details od ON o.orderid = od.orderid
    WHERE DATE_PART('year', o.orderdate) BETWEEN 2015 AND 2020
    GROUP BY c.customerid, DATE_PART('year', o.orderdate)
),
customer_ranks AS (
    SELECT customerid, order_year, avg_order_amount,
        ROW_NUMBER() OVER (PARTITION BY order_year ORDER BY avg_order_amount DESC) AS rank
    FROM customer_avg_orders
    WHERE customerid IN (
        SELECT customerid
        FROM orders
        WHERE DATE_PART('year', orderdate) BETWEEN 2015 AND 2020
        GROUP BY customerid
        HAVING COUNT(DISTINCT DATE_PART('year', orderdate)) = 6
    )
)
SELECT cr.customerid, cr.avg_order_amount, cr.order_year
FROM customer_ranks cr
WHERE cr.rank <= 5
ORDER BY cr.avg_order_amount DESC;

-- 10. Calculate the monthly order growth rate for each category, comparing the number of 
-- orders in the current month with the number of orders in the previous month. 
-- Display the category name, current month, previous month, and the growth rate in percentage. 
-- Order the results by category name and current month.

WITH monthly_orders AS (
    SELECT 
        c.categoryname,
        DATE_TRUNC('month', o.orderdate) AS month,
        COUNT(DISTINCT o.orderid) AS num_orders,
        ROW_NUMBER() OVER (PARTITION BY c.categoryname ORDER BY DATE_TRUNC('month', o.orderdate)) AS rn
    FROM categories c
    JOIN products p ON c.categoryid = p.categoryid
    JOIN order_details od ON p.productid = od.productid
    JOIN orders o ON od.orderid = o.orderid
    GROUP BY c.categoryname, DATE_TRUNC('month', o.orderdate)
)
SELECT 
    mo1.categoryname,
    TO_CHAR(mo2.month, 'Mon YYYY') AS current_month,
    TO_CHAR(mo1.month, 'Mon YYYY') AS previous_month,
    ROUND(((mo2.num_orders - mo1.num_orders) / mo1.num_orders::numeric) * 100, 2) AS growth_rate
FROM monthly_orders mo1
JOIN monthly_orders mo2 ON mo1.categoryname = mo2.categoryname AND mo1.rn + 1 = mo2.rn
ORDER BY mo1.categoryname, mo2.month;
