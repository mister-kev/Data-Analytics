/* 1. Write a SQL statement to prepare a list with salesman name, customer name and their cities for the salesmen and customer who belongs to the same city. */

SELECT s.name,
       c.cust_name,
       c.city
  FROM salesman s
  INNER JOIN customer c
    ON s.city = c.city;


/* 2. Write a SQL statement to make a list with order no, purchase amount, customer name and their cities for those orders which order amount between 500 and 2000 */

SELECT o.ord_no,
       o.purch_amt,
       c.cust_name, 
       c.city
  FROM orders o
  INNER JOIN customer c
    ON o.customer_id = c.customer_id
  WHERE o.purch_amt BETWEEN 500 AND 2000;


/* 3. Write a SQL statement to know which salesman are working for which customer. */

SELECT c.cust_name AS "Customer Name",
       s.name AS "Salesman"
  FROM customer c
  INNER JOIN salesman s
    ON c.salesman_id = s.salesman_id;


/* 4. Write a SQL statement to find the list of customers who appointed a salesman for their jobs who gets a commission from the company is more than 12%. */

SELECT c.cust_name AS "Customer Name",
       c.city,
       s.name AS "Salesman",
       s.commission
  FROM customer c
  INNER JOIN salesman s
    ON c.salesman_id = s.salesman_id
  WHERE s.commission > 0.12;


/* 5. Write a SQL statement to find the list of customers who appointed a salesman for their jobs who does not live in the same city where their customer lives, and gets a commission is above 12% . */

SELECT c.cust_name AS "Customer Name",
       c.city AS "Customer City",
       s.name AS "Salesman",
       s.city AS "Salesman City",
       s.commission
  FROM customer c
  INNER JOIN salesman s
    ON c.salesman_id = s.salesman_id
  WHERE s.commission > 0.12
    AND c.city != s.city;


/* 6. Write a SQL statement to find the details of an order i.e. order number, order date, amount of order, which customer gives the order and which salesman works for that customer and how much commission he gets for an order. */

SELECT o.ord_no,
       o.ord_date,
       o.purch_amt,
       c.cust_name AS "Customer Name",
       s.name AS "Salesman",
       s.commission 
  FROM orders o
  INNER JOIN customer c
    ON o.customer_id=c.customer_id 
  INNER JOIN salesman s
    ON o.salesman_id=s.salesman_id;


/* 7. Write a SQL statement to make a join on the tables salesman, customer and orders in such a form that the same column of each table will appear once and only the relational rows will come.

SELECT *
  FROM orders
  NATURAL JOIN customer
  NATURAL JOIN salesman;


/* 8. Write a SQL statement to make a list in ascending order for the customer who works either through a salesman or by own. */

SELECT c.cust_name AS "Customer Name"
  FROM customer c
  LEFT JOIN salesman s
    ON c.salesman_id=s.salesman_id
  ORDER BY c.customer_id ASC;


/* 9. Write a SQL statement to make a list in ascending order for the customer who holds a grade less than 300 and works either through a salesman or by own. */

SELECT c.cust_name AS "Customer Name",
       c.grade
  FROM customer c
  LEFT JOIN salesman s
    ON c.salesman_id=s.salesman_id
  WHERE c.grade < 300
  ORDER BY c.customer_id ASC;


/* 10. Write a SQL statement to make a report with customer name, city, order number, order date, and order amount in ascending order according to the order date to find that either any of the existing customers have placed no order or placed one or more orders. */

SELECT c.cust_name AS "Customer Name",
       c.city,
       o.ord_no,
       o.ord_date,
       o.purch_amt
  FROM customer c
  LEFT OUTER JOIN orders o
    ON c.customer_id=o.customer_id
  ORDER BY o.ord_date;


/* 11. Write a SQL statement to make a report with customer name, city, order number, order date, order amount, salesman name and commission to find that either any of the existing customers have placed no order or placed one or more orders by their salesman or by own. */

SELECT c.cust_name AS "Customer Name",
       c.city,
       o.ord_no,
       o.ord_date,
       o.purch_amt,
       s.name AS "Salesman",
       s.commission
  FROM customer c
  LEFT OUTER JOIN orders o
    ON c.customer_id=o.customer_id
  LEFT OUTER JOIN salesman s
    ON c.salesman_id=s.salesman_id;


/* 12. Write a SQL statement to make a list in ascending order for the salesmen who works either for one or more customer or not yet join under any of the customers. */

SELECT s.name AS "Salesman"
  FROM salesman s
  LEFT OUTER JOIN customer c
    ON s.salesman_id=c.salesman_id
  ORDER BY c.salesman_id ASC;


/* 13. Write a SQL statement to make a list for the salesmen who works either for one or more customer or not yet join under any of the customers who placed either one or more orders or no order to their supplier. */

SELECT s.name AS "Salesman"
  FROM salesman s
  LEFT OUTER JOIN customer c
    ON s.salesman_id=c.salesman_id
  LEFT OUTER JOIN orders o
    ON c.customer_id=o.customer_id;


/* 14. Write a SQL statement to make a list for the salesmen who either work for one or more customers or yet to join any of the customer. The customer may have placed, either one or more orders on or above order amount 2000 and must have a grade, or he may not have placed any order to the associated supplier. /*

SELECT s.name AS "Salesman"
  FROM salesman s
  LEFT OUTER JOIN customer c
    ON s.salesman_id=c.salesman_id
  LEFT OUTER JOIN orders o
    ON c.customer_id=o.customer_id
  WHERE o.purch_amt >= 2000
    AND grade IS NOT NULL;


/* 15. Write a SQL statement to make a report with customer name, city, order no, order date, purchase amount for those customers from the existing list who placed one or more orders or which order(s) have been placed by the customer who is not on the list. */

SELECT c.cust_name AS "Customer Name",
       c.city,
       o.ord_no,
       o.ord_date,
       o.purch_amt
  FROM customer c
  RIGHT JOIN orders o
    ON c.customer_id= o.customer_id;


/* 16. Write a SQL statement to make a report with customer name, city, order no. order date, purchase amount for only those customers on the list who must have a grade and placed one or more orders or which order(s) have been placed by the customer who is neither in the list nor have a grade. */

SELECT c.cust_name AS "Customer Name",
       c.city,
       o.ord_no,
       o.ord_date,
       o.purch_amt
  FROM customer c
  FULL OUTER JOIN orders o
    ON c.customer_id= o.customer_id
      AND c.grade IS NOT NULL;


/* 17. Write a SQL statement to make a cartesian product between salesman and customer i.e. each salesman will appear for all customer and vice versa. */

SELECT s.name AS "Salesman",
       c.cust_name AS "Customer Name"
  FROM salesman s
  CROSS JOIN customer c;


/* 18. Write a SQL statement to make a cartesian product between salesman and customer i.e. each salesman will appear for all customer and vice versa for that customer who belongs to a city. */

SELECT s.name AS "Salesman",
       c.cust_name AS "Customer Name"
  FROM salesman s
  CROSS JOIN customer c
  WHERE s.city IS NOT NULL;


/* 19. Write a SQL statement to make a cartesian product between salesman and customer i.e. each salesman will appear for all customer and vice versa for those salesmen who belongs to a city and the customers who must have a grade. */

SELECT s.name AS "Salesman",
       c.cust_name AS "Customer Name"
  FROM salesman s
  CROSS JOIN customer c
  WHERE s.city IS NOT NULL
    AND c.grade IS NOT NULL;


/* 20. Write a SQL statement to make a cartesian product between salesman and customer i.e. each salesman will appear for all customer and vice versa for those salesmen who must belong a city which is not the same as his customer and the customers should have an own grade. */

SELECT s.name AS "Salesman",
       c.cust_name AS "Customer Name"
  FROM salesman s
  CROSS JOIN customer c
  WHERE s.city IS NOT NULL
    AND s.city != c.city
    AND c.grade IS NOT NULL;


/* 21. Write a SQL query to display all the data from the item_mast, including all the data for each item's producer company. */

SELECT *
  FROM item_mast i
  INNER JOIN company_mast c
    ON i.pro_com=c.com_id;


/* 22. Write a SQL query to display the item name, price, and company name of all the products. */

SELECT i.pro_name,
       i.pro_price,
       c.com_name
  FROM item_mast i
  INNER JOIN company_mast c
    ON i.pro_com=c.com_id;


/* 23. Write a SQL query to display the average price of items of each company, showing the name of the company. */

SELECT c.com_name,
       AVG(i.pro_price)
  FROM item_mast i
  INNER JOIN company_mast c
    ON i.pro_com=c.com_id
  GROUP BY c.com_name;


/* 24. Write a SQL query to display the names of the company whose products have an average price larger than or equal to Rs. 350. */

SELECT c.com_name,
       AVG(i.pro_price)
  FROM item_mast i
  INNER JOIN company_mast c
    ON i.pro_com=c.com_id
  GROUP BY c.com_name
  HAVING AVG(i.pro_price) >= 350;


/* 25. Write a SQL query to display the name of each company along with the ID and price for their most expensive product. */

SELECT c.com_name,
       i.pro_name,
       i.pro_price
  FROM item_mast i
  INNER JOIN company_mast c
    ON i.pro_com=c.com_id
      AND i.pro_price = (SELECT MAX(i.pro_price)
                           FROM item_mast i
                           WHERE i.pro_com = c.com_id);


/* 26. Write a query in SQL to display all the data of employees including their department. */

SELECT *
  FROM emp_details edet
  INNER JOIN emp_department edep
    ON edet.emp_dept = edep.dpt_code;


/* 27. Write a query in SQL to display the first name and last name of each employee, along with the name and sanction amount for their department. */

SELECT edet.emp_fname AS "First Name",
       edet.emp_lname AS "Last Name",
       edep.dpt_name AS "Department Name",
       edep.dpt_allotment AS "Amount Allotted"
  FROM emp_details edet
  INNER JOIN emp_department edep
    ON edet.emp_dept = edep.dpt_code;


/* 28. Write a query in SQL to find the first name and last name of employees working for departments with a budget more than Rs. 50000. */

SELECT edet.emp_fname AS "First Name",
       edet.emp_lname AS "Last Name"
  FROM emp_details edet
  INNER JOIN emp_department edep
    ON edet.emp_dept = edep.dpt_code
      AND edep.dpt_allotment > 50000;


/* 29. Write a query in SQL to find the names of departments where more than two employees are working. */

SELECT edep.dpt_name,
       COUNT(edet.emp_idno)
  FROM emp_details edet
  INNER JOIN emp_department edep
    ON edet.emp_dept = edep.dpt_code
  GROUP BY edep.dpt_name
  HAVING COUNT(edet.emp_idno) > 2;
