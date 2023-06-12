/*** SQL Exercises - SUBQUERIES on Sales Database ***/
-- https://www.w3resource.com/sql-exercises/subqueries/index.php

Table: salesman

salesman_id  name        city        commission
-----------  ----------  ----------  ----------
5001         James Hoog  New York    0.15
5002         Nail Knite  Paris       0.13
5005         Pit Alex    London      0.11
5006         Mc Lyon     Paris       0.14
5003         Lauson Hen              0.12
5007         Paul Adam   Rome        0.13


Table: customer

customer_id  cust_name     city        grade       salesman_id
-----------  ------------  ----------  ----------  -----------
3002         Nick Rimando  New York    100         5001
3005         Graham Zusi   California  200         5002
3001         Brad Guzan    London                  5005
3004         Fabian Johns  Paris       300         5006
3007         Brad Davis    New York    200         5001
3009         Geoff Camero  Berlin      100         5003
3008         Julian Green  London      300         5002
3003         Jozy Altidor  Moscow      200         5007


Table: orders

ord_no      purch_amt   ord_date    customer_id  salesman_id
----------  ----------  ----------  -----------  -----------
70001       150.5       2012-10-05  3005         5002
70009       270.65      2012-09-10  3001         5005
70002       65.26       2012-10-05  3002         5001
70004       110.5       2012-08-17  3009         5003
70007       948.5       2012-09-10  3005         5002
70005       2400.6      2012-07-27  3007         5001
70008       5760        2012-09-10  3002         5001
70010       1983.43     2012-10-10  3004         5006
70003       2480.4      2012-10-10  3009         5003
70012       250.45      2012-06-27  3008         5002
70011       75.29       2012-08-17  3003         5007
70013       3045.6      2012-04-25  3002         5001


Table: company_mast

COM_ID COM_NAME
------ -------------
    11 Samsung
    12 iBall
    13 Epsion
    14 Zebronics
    15 Asus
    16 Frontech


Table: item_mast

PRO_ID PRO_NAME                   PRO_PRICE    PRO_COM
------- ------------------------- ---------- ----------
    101 Mother Board                    3200         15
    102 Key Board                        450         16
    103 ZIP drive                        250         14
    104 Speaker                          550         16
    105 Monitor                         5000         11
    106 DVD drive                        900         12
    107 CD drive                         800         12
    108 Printer                         2600         13
    109 Refill cartridge                 350         13
    110 Mouse                            250         12


Table: emp_department

DPT_CODE DPT_NAME        DPT_ALLOTMENT
-------- --------------- -------------
      57 IT                      65000
      63 Finance                 15000
      47 HR                     240000
      27 RD                      55000
      89 QC                      75000


Table: emp_details

EMP_IDNO EMP_FNAME       EMP_LNAME         EMP_DEPT
--------- --------------- --------------- ----------
   127323 Michale         Robbin                  57
   526689 Carlos          Snares                  63
   843795 Enric           Dosio                   57
   328717 Jhon            Snares                  63
   444527 Joseph          Dosni                   47
   659831 Zanifer         Emily                   47
   847674 Kuleswar        Sitaraman               57
   748681 Henrey          Gabriel                 47
   555935 Alex            Manuel                  57
   539569 George          Mardy                   27
   733843 Mario           Saule                   63
   631548 Alan            Snappy                  27
   839139 Maria           Foster                  57


/* 1. Write a query to display all the orders from the orders table issued by the salesman 'Paul Adam'. */

/* 2. Write a query to display all the orders for the salesman who belongs to the city London. *.'

/* 3. Write a query to find all the orders issued against the salesman who may works for customer whose id is 3007. *.

/* 4. Write a query to display all the orders which values are greater than the average order value for 10th October 2012. /*

/* 5. Write a query to find all orders attributed to a salesman in New York. */

/* 6. Write a query to display the commission of all the salesmen servicing customers in Paris. */

/* 7. Write a query to display all the customers whose id is 2001 bellow the salesman ID of Mc Lyon. */

/* 8. Write a query to count the customers with grades above New York's average. */
  
/* 9. Write a query to display all customers with orders on October 5, 2012. */

/* 10. Write a query to display all the customers with orders issued on date 17th August, 2012. */

/* 11. Write a query to find the name and numbers of all salesmen who had more than one customer. */

/* 12. Write a query to find all orders with order amounts which are above-average amounts for their customers. */

/* 13. Write a queries to find all orders with order amounts which are on or above-average amounts for their customers. */

/* 14. Write a query to find the sums of the amounts from the orders table, grouped by date, eliminating all those dates where the sum was not at least 1000.00 above the maximum order amount for that date. */

/* 15. Write a query to extract the data from the customer table if and only if one or more of the customers in the customer table are located in London. */

/* 16. Write a query to find the salesmen who have multiple customers. */

/* 17. Write a query to find all the salesmen who worked for only one customer. */

/* 18. Write a query that extract the rows of all salesmen who have customers with more than one orders. */

/* 19. Write a query to find salesmen with all information who lives in the city where any of the customers lives. */

/* 20. Write a query to find all the salesmen for whom there are customers that follow them. */

/* 21. Write a query to display the salesmen which name are alphabetically lower than the name of the customers. */

/* 22. Write a query to display the customers who have a greater gradation than any customer who belongs to the alphabetically lower than the city New York. */=

/* 23. Write a query to display all the orders that had amounts that were greater than at least one of the orders on September 10th 2012. */

/* 24. Write a query to find all orders with an amount smaller than any amount for a customer in London. */

/* 25. Write a query to display all orders with an amount smaller than the maximum amount for a customers in London. */

/* 26. Write a query to display only those customers whose grade are, in fact, higher than every customer in New York. */

/* 27. Write a query to find only those customers whose grade are, higher than every customer to the city New York. */

/* 28. Write a query to get all the information for those customers whose grade is not as the grade of customer who belongs to the city London */

/* 29. Write a query to find all those customers whose grade are not as the grade, belongs to the city Paris. */

/* 30. Write a query to find all those customers who hold a different grade than any customer of the city Dallas. */

/* 31. Write a SQL query to find the average price of each manufacturer's products along with their name. */

/* 32. Write a SQL query to display the average price of the products which is more than or equal to 350 along with their names. */

/* 33. Write a SQL query to display the name of each company, price for their most expensive product along with their Name. */

/* 34. Write a query in SQL to find all the details of employees whose last name is Gabriel or Dosio. */

/* 35. Write a query in SQL to display all the details of employees who works in department 89 or 63. */

/* 36. Write a query in SQL to display the first name and last name of employees working for the department which allotment amount is more than Rs.50000. */

/* 37. Write a query in SQL to find the departments which sanction amount is larger than the average sanction amount of all the departments. */

/* 38. Write a query in SQL to find the names of departments with more than two employees are working. */

/* 39. Write a query in SQL to find the first name and last name of employees working for departments which sanction amount is second lowest. */
