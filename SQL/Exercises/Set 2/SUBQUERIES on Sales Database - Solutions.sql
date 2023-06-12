/* 1. Write a query to display all the orders from the orders table issued by the salesman 'Paul Adam'. */

SELECT *
  FROM orders
  WHERE salesman_id = (SELECT salesman_id
                         FROM salesman
                         WHERE name = 'Paul Adam');


/* 2. Write a query to display all the orders for the salesman who belongs to the city London. *.'

SELECT *
  FROM orders
  WHERE salesman_id = (SELECT salesman_id
                         FROM salesman
                         WHERE city = 'London');


/* 3. Write a query to find all the orders issued against the salesman who may works for customer whose id is 3007. *.

SELECT *
  FROM orders
  WHERE salesman_id = (SELECT salesman_id
                         FROM orders
                         WHERE customer_id = 3007);


/* 4. Write a query to display all the orders which values are greater than the average order value for 10th October 2012. /*

SELECT *
  FROM orders
  WHERE purch_amt > (SELECT AVG(purch_amt)
                       FROM orders
                       WHERE ord_date = '2012-10-10');


/* 5. Write a query to find all orders attributed to a salesman in New York. */

SELECT *
  FROM orders
  WHERE salesman_id IN (SELECT salesman_id
                          FROM salesman
                          WHERE city = 'New York');


/* 6. Write a query to display the commission of all the salesmen servicing customers in Paris. */

SELECT commission
  FROM salesman
  WHERE salesman_id IN (SELECT salesman_id
                          FROM customer
                          WHERE city = 'Paris');


/* 7. Write a query to display all the customers whose id is 2001 bellow the salesman ID of Mc Lyon. */

SELECT *
  FROM customer
  WHERE customer_id = (SELECT salesman_id - 2001
                         FROM salesman
                         WHERE name = 'Mc Lyon');


/* 8. Write a query to count the customers with grades above New York's average. */

SELECT COUNT(*)
  FROM customer
  WHERE grade > (SELECT AVG(grade)
                   FROM customer
                   WHERE city = 'New York');


/* 9. Write a query to display all customers with orders on October 5, 2012. */
/* Note: These set of exercises focus on subqueries, so I wrote the query below.  The 2nd query also works and displays order information as well. */

SELECT *
  FROM customer
  WHERE customer_id IN (SELECT customer_id
                          FROM orders
                          WHERE ord_date = '2012-10-05');

SELECT *
  FROM customer a, orders b 
  WHERE a.customer_id = b.customer_id 
    AND b.ord_date = '2012-10-05';


/* 10. Write a query to display all the customers with orders issued on date 17th August, 2012. */
/* Note: These set of exercises focus on subqueries, so I wrote the query below.  The 2nd query also works and displays order information as well. */

SELECT *
  FROM customer
  WHERE customer_id IN (SELECT customer_id
                          FROM orders
                          WHERE ord_date = '2012-08-17');

SELECT b.*,
       a.cust_name
  FROM customer a, orders b 
  WHERE a.customer_id = b.customer_id 
    AND b.ord_date = '2012-08-17';


/* 11. Write a query to find the name and numbers of all salesmen who had more than one customer. */

SELECT salesman_id,
       name
  FROM salesman
  WHERE salesman_id IN (SELECT salesman_id
                          FROM customer
                          GROUP BY salesman_id
                          HAVING COUNT(*) > 1);

SELECT salesman_id,
        name 
  FROM salesman a 
  WHERE 1 < (SELECT COUNT(*)
               FROM customer 
               WHERE salesman_id = a.salesman_id);


/* 12. Write a query to find all orders with order amounts which are above-average amounts for their customers. */

SELECT *
  FROM orders a
  WHERE purch_amt > (SELECT AVG(purch_amt)
                       FROM orders b
                       WHERE b.customer_id = a.customer_id);


/* 13. Write a queries to find all orders with order amounts which are on or above-average amounts for their customers. */

SELECT *
  FROM orders a
  WHERE purch_amt >= (SELECT AVG(purch_amt)
                        FROM orders b
                        WHERE b.customer_id = a.customer_id);


/* 14. Write a query to find the sums of the amounts from the orders table, grouped by date, eliminating all those dates where the sum was not at least 1000.00 above the maximum order amount for that date. */

SELECT ord_date,
       SUM(purch_amt)
  FROM orders a
  GROUP BY ord_date
  HAVING SUM(purch_amt) > (SELECT MAX(purch_amt) + 1000
                             FROM orders b
                             WHERE a.ord_date = b.ord_date);


/* 15. Write a query to extract the data from the customer table if and only if one or more of the customers in the customer table are located in London. */

SELECT *
  FROM customer
  WHERE EXISTS (SELECT *
                  FROM customer
                  WHERE city = 'London');


/* 16. Write a query to find the salesmen who have multiple customers. */

SELECT *
  FROM salesman
  WHERE salesman_id IN (SELECT salesman_id
                          FROM customer
                          GROUP BY salesman_id
                          HAVING COUNT(*) > 1);

SELECT *
  FROM salesman 
  WHERE salesman_id IN (SELECT DISTINCT salesman_id 
                          FROM customer a 
                          WHERE EXISTS (SELECT *
                                          FROM customer b 
                                          WHERE b.salesman_id=a.salesman_id 
                                            AND b.cust_name <> a.cust_name));


/* 17. Write a query to find all the salesmen who worked for only one customer. */

SELECT *
  FROM salesman
  WHERE salesman_id IN (SELECT salesman_id
                          FROM customer
                          GROUP BY salesman_id
                          HAVING COUNT(customer_id) = 1);


/* 18. Write a query that extract the rows of all salesmen who have customers with more than one orders. */

SELECT *
  FROM salesman
  WHERE salesman_id IN (SELECT salesman_id
                          FROM customer
                          WHERE customer_id IN (SELECT customer_id
                                                  FROM orders
                                                  GROUP BY customer_id
                                                  HAVING COUNT(*) > 1));

SELECT *
  FROM salesman a 
  WHERE EXISTS (SELECT *
                  FROM customer b     
                  WHERE a.salesman_id=b.salesman_id     
	            AND 1 < (SELECT COUNT(*)              
		               FROM orders             
		               WHERE orders.customer_id=b.customer_id));


/* 19. Write a query to find salesmen with all information who lives in the city where any of the customers lives. */

SELECT *
  FROM salesman
  WHERE city IN (SELECT city
                   FROM customer);

SELECT *
  FROM salesman 
  WHERE city = ANY (SELECT city
                      FROM customer);


/* 20. Write a query to find all the salesmen for whom there are customers that follow them. */

SELECT *
  FROM salesman 
  WHERE city IN (SELECT city
                   FROM customer);


/* 21. Write a query to display the salesmen which name are alphabetically lower than the name of the customers. */

SELECT *
  FROM salesman a
  WHERE EXISTS (SELECT *
                  FROM customer b
                  WHERE a.name < b.cust_name);


/* 22. Write a query to display the customers who have a greater gradation than any customer who belongs to the alphabetically lower than the city New York. */

SELECT *
  FROM customer
  WHERE grade > ANY (SELECT grade
                       FROM customer
                       WHERE city < 'New York');


/* 23. Write a query to display all the orders that had amounts that were greater than at least one of the orders on September 10th 2012. */

SELECT *
  FROM orders
  WHERE purch_amt > ANY (SELECT purch_amt
                           FROM orders
                           WHERE ord_date = '2012-09-10');


/* 24. Write a query to find all orders with an amount smaller than any amount for a customer in London. */

SELECT *
  FROM orders
  WHERE purch_amt < ANY (SELECT purch_amt
                           FROM orders
                           WHERE customer_id IN (SELECT customer_id
                                                   FROM customer
                                                   WHERE city = 'London'));

SELECT *
  FROM orders
  WHERE purch_amt < ANY (SELECT purch_amt
	                   FROM orders a, customer b
	                   WHERE a.customer_id = b.customer_id
	                     AND b.city = 'London');


/* 25. Write a query to display all orders with an amount smaller than the maximum amount for a customers in London. */

SELECT *
  FROM orders
  WHERE purch_amt < (SELECT MAX(purch_amt)
                       FROM orders
                       WHERE customer_id IN (SELECT customer_id
					       FROM customer
					       WHERE city = 'London'));

SELECT *
  FROM orders
  WHERE purch_amt < (SELECT MAX(purch_amt)
	               FROM orders a, customer b
	               WHERE a.customer_id = b.customer_id
	                 AND b.city = 'London');


/* 26. Write a query to display only those customers whose grade are, in fact, higher than every customer in New York. */

SELECT *
  FROM customer
  WHERE grade > ALL (SELECT grade
                       FROM customer 
                       WHERE city = 'New York');


/* 27. Write a query to find only those customers whose grade are, higher than every customer to the city New York. */

SELECT *
  FROM customer
  WHERE grade > ALL (SELECT grade
                       FROM customer 
                       WHERE city = 'New York');


/* 28. Write a query to get all the information for those customers whose grade is not as the grade of customer who belongs to the city London */

SELECT *
  FROM customer
  WHERE grade != ANY (SELECT grade
                        FROM customer 
                        WHERE city = 'London');


/* 29. Write a query to find all those customers whose grade are not as the grade, belongs to the city Paris. */

SELECT *
  FROM customer
  WHERE grade != ANY (SELECT grade
                        FROM customer 
                        WHERE city = 'Paris');

SELECT *
  FROM customer
  WHERE grade NOT IN (SELECT grade
                        FROM customer 
                        WHERE city = 'Paris');


/* 30. Write a query to find all those customers who hold a different grade than any customer of the city Dallas. */

SELECT *
  FROM customer
  WHERE grade NOT IN (SELECT grade
                        FROM customer 
                        WHERE city = 'Dallas');

SELECT *
FROM customer 
WHERE NOT grade = ANY (SELECT grade
	                 FROM customer
	                 WHERE city = 'Dallas');


/* 31. Write a SQL query to find the average price of each manufacturer's products along with their name. */

SELECT AVG(pro_price),
       com_name
  FROM item_mast, company_mast
  WHERE item_mast.pro_com = company_mast.com_id
  GROUP BY com_name;


/* 32. Write a SQL query to display the average price of the products which is more than or equal to 350 along with their names. */

SELECT c.com_name,
       AVG(i.pro_price)
  FROM item_mast i
  INNER JOIN company_mast c
    ON i.pro_com=c.com_id
  GROUP BY c.com_name
  HAVING AVG(i.pro_price) >= 350;

SELECT AVG(pro_price) AS "Average Price",
       company_mast.com_name AS "Company"
  FROM item_mast, company_mast
  WHERE item_mast.pro_com = company_mast.com_id
  GROUP BY company_mast.com_name
  HAVING AVG(pro_price) >= 350;


/* 33. Write a SQL query to display the name of each company, price for their most expensive product along with their Name. */

SELECT c.com_name,
       i.pro_name,
       i.pro_price
  FROM item_mast i
  INNER JOIN company_mast c
    ON i.pro_com = c.com_id
      AND i.pro_price = (SELECT MAX(i.pro_price)
                           FROM item_mast i
                           WHERE i.pro_com = c.com_id);

SELECT c.com_name,
       i.pro_name,
       i.pro_price
   FROM item_mast i, company_mast c
   WHERE i.pro_com = c.com_id
     AND i.pro_price = (SELECT MAX(i.pro_price)
                          FROM item_mast i
                          WHERE i.pro_com = c.com_id);


/* 34. Write a query in SQL to find all the details of employees whose last name is Gabriel or Dosio. */

SELECT *
  FROM emp_details
  WHERE emp_lname IN ('Gabriel', 'Dosio');


/* 35. Write a query in SQL to display all the details of employees who works in department 89 or 63. */

SELECT *
  FROM emp_details
  WHERE emp_dept IN (89, 63);


/* 36. Write a query in SQL to display the first name and last name of employees working for the department which allotment amount is more than Rs.50000. */

SELECT emp_fname,
       emp_lname
  FROM emp_details
  WHERE emp_dept IN (SELECT dpt_code
                       FROM emp_department
                       WHERE dpt_allotment > 50000);


/* 37. Write a query in SQL to find the departments which sanction amount is larger than the average sanction amount of all the departments. */

SELECT *
  FROM emp_department
  WHERE dpt_allotment > (SELECT AVG(dpt_allotment)
                           FROM emp_department);


/* 38. Write a query in SQL to find the names of departments with more than two employees are working. */

SELECT dpt_name
  FROM emp_department
  WHERE dpt_code IN (SELECT emp_dept
                       FROM emp_details
                       GROUP BY emp_dept
                       HAVING COUNT(*) > 2);


/* 39. Write a query in SQL to find the first name and last name of employees working for departments which sanction amount is second lowest. */

SELECT emp_fname,
       emp_lname
  FROM emp_details
  WHERE emp_dept IN (SELECT dpt_code
                       FROM emp_department
                       WHERE dpt_allotment = (SELECT MIN(dpt_allotment)
                                                FROM emp_department
                                                WHERE dpt_allotment > (SELECT MIN(dpt_allotment) 
                                                                         FROM emp_department)));
