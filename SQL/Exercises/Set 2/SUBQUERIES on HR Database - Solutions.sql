/* 1. Write a query to display the name (first name and last name) for those employees who gets more salary than the employee whose ID is 163. */

SELECT first_name,
       last_name
  FROM employees
  WHERE salary > (SELECT salary
                    FROM employees
                    WHERE employee_id = 163);


/* 2. Write a query to display the name (first name and last name), salary, department id, job id for those employees who works in the same designation as the employee works whose id is 169. */

SELECT first_name,
       last_name,
       salary,
       department_id,
       job_id
  FROM employees
  WHERE job_id = (SELECT job_id
                    FROM employees
                    WHERE employee_id = 169);


/* 3. Write a query to display the name (first name and last name), salary, department id for those employees who earn such amount of salary which is the smallest salary of any of the departments. */

SELECT first_name,
       last_name,
       salary,
       department_id
  FROM employees
  WHERE salary IN (SELECT MIN(salary)
                     FROM employees
                     GROUP BY department_id);


/* 4. Write a query to display the employee id, employee name (first name and last name) for all employees who earn more than the average salary. */

SELECT employee_id,
       first_name,
       last_name
  FROM employees
  WHERE salary > (SELECT AVG(salary)
                    FROM employees);


/* 5. Write a query to display the employee name (first name and last name), employee id and salary of all employees who report to Payam. */

SELECT first_name,
       last_name,
       employee_id,
       salary
  FROM employees
  WHERE manager_id = (SELECT employee_id
                        FROM employees
                        WHERE first_name = 'Payam');


/* 6. Write a query to display the department number, name (first name and last name), job_id and department name for all employees in the Finance department. */

SELECT e.department_id,
       e.first_name,
       e.last_name,
       e.job_id,
       d.department_name
  FROM employees e
  INNER JOIN departments d
    ON e.department_id = d.department_id
  WHERE d.department_name = 'Finance';


/* 7. Write a query to display all the information of an employee whose salary and reporting person id is 3000 and 121, respectively. */

SELECT *
  FROM employees
  WHERE salary = 3000.00
    AND manager_id = 121;

-- Note: This also works using subquery.

SELECT *
  FROM employees 
  WHERE (salary, manager_id) = (SELECT 3000, 121);


/* 8. Display all the information of an employee whose id is any of the number 134, 159 and 183. */

SELECT *
  FROM employees
  WHERE employee_id IN (134, 159, 183);


/* 9. Write a query to display all the information of the employees whose salary is within the range 1000 and 3000. */

SELECT *
  FROM employees
  WHERE salary BETWEEN 1000.00 AND 3000.00;


/* 10. Write a query to display all the information of the employees whose salary is within the range of smallest salary and 2500. */

SELECT *
  FROM employees
  WHERE salary BETWEEN (SELECT MIN(salary)
                          FROM employees) AND 2500.00;


/* 11. Write a query to display all the information of the employees who does not work in those departments where some employees works whose manager id within the range 100 and 200. */

SELECT *
  FROM employees
  WHERE department_id NOT IN (SELECT department_id
                                FROM departments
                                WHERE manager_id BETWEEN 100 AND 200);


/* 12. Write a query to display all the information for those employees whose id is any id who earn the second highest salary. */

SELECT *
  FROM employees
  WHERE employee_id IN (SELECT employee_id
                          FROM employees
                          WHERE salary IN (SELECT MAX(salary)
                                             FROM employees
                                             WHERE salary < (SELECT MAX(salary)
                                                               FROM employees)));


/* 13. Write a query to display the employee name (first name and last name) and hire date for all employees in the same department as Clara. Exclude Clara. */

SELECT first_name,
       last_name,
       hire_date
  FROM employees
  WHERE department_id = (SELECT department_id
                           FROM employees
                           WHERE first_name = 'Clara')
    AND first_name != 'Clara';


/* 14. Write a query to display the employee number and name (first name and last name) for all employees who work in a department with any employee whose name contains a T. */

SELECT employee_id,
       first_name,
       last_name
  FROM employees
  WHERE department_id IN (SELECT department_id
                            FROM employees
                            WHERE first_name LIKE '%T%');


/* 15. Write a query to display the employee number, name (first name and last name), and salary for all employees who earn more than the average salary and who work in a department with any employee with a J in their name. */

SELECT employee_id,
       first_name,
       last_name,
       salary
  FROM employees
  WHERE salary > (SELECT AVG(salary)
                    FROM employees)
    AND department_id IN (SELECT department_id
                            FROM employees
                            WHERE first_name LIKE '%J%');


/* 16. Display the employee name (first name and last name), employee id, and job title for all employees whose department location is Toronto. */

SELECT first_name,
       last_name,
       employee_id,
       job_id
  FROM employees
  WHERE department_id IN (SELECT department_id
                            FROM departments
                            WHERE location_id IN (SELECT location_id
                                                    FROM locations
                                                    WHERE city = 'Toronto'));


/* 17. Write a query to display the employee number, name (first name and last name) and job title for all employees whose salary is smaller than any salary of those employees whose job title is MK_MAN. */

SELECT employee_id,
       first_name,
       last_name,
       job_id
  FROM employees
  WHERE salary < ANY (SELECT salary
                        FROM employees
                        WHERE job_id = 'MK_MAN');


/* 18. Write a query to display the employee number, name (first name and last name) and job title for all employees whose salary is smaller than any salary of those employees whose job title is MK_MAN. Exclude Job title MK_MAN. */

SELECT employee_id,
       first_name,
       last_name,
       job_id
  FROM employees
  WHERE salary < ANY (SELECT salary
                        FROM employees
                        WHERE job_id = 'MK_MAN')
    AND job_id != 'MK_MAN';


/* 19. Write a query to display the employee number, name (first name and last name) and job title for all employees whose salary is more than any salary of those employees whose job title is PU_MAN. Exclude job title PU_MAN. */

SELECT employee_id,
       first_name,
       last_name,
       job_id
  FROM employees
  WHERE salary > ANY (SELECT salary
                        FROM employees
                        WHERE job_id = 'PU_MAN')
    AND job_id != 'PU_MAN';


/* 20. Write a query to display the employee number, name (first name and last name) and job title for all employees whose salary is more than any average salary of any department. */

SELECT employee_id,
       first_name,
       last_name,
       job_id
  FROM employees
  WHERE salary > ANY (SELECT AVG(salary)
                        FROM employees
                        GROUP BY department_id);


/* 21. Write a query to display the employee name( first name and last name ) and department for all employees for any existence of those employees whose salary is more than 3700. */

SELECT first_name,
       last_name,
       department_id
  FROM employees
  WHERE EXISTS (SELECT *
                  FROM employees
                  WHERE salary > 3700.00);


/* 22. Write a query to display the department id and the total salary for those departments which contains at least one employee. */

SELECT department_id,
       SUM(salary)
  FROM employees
  WHERE department_id IN (SELECT department_id
                            FROM departments)
  GROUP BY department_id
  HAVING COUNT(department_id) >= 1;


/* 23. Write a query to display the employee id, name (first name and last name) and the job id column with a modified title SALESMAN for those employees whose job title is ST_MAN and DEVELOPER for whose job title is IT_PROG. */

SELECT employee_id,
       first_name,
       last_name,
       CASE WHEN job_id = 'ST_MAN' THEN 'SALESMAN'
            WHEN job_id = 'IT_PROG' THEN 'DEVELOPER'
            ELSE job_id END AS job_id_mod
  FROM employees;


/* 24. Write a query to display the employee id, name (first name and last name), salary and the SalaryStatus column with a title HIGH and LOW respectively for those employees whose salary is more than and less than the average salary of all employees. */

SELECT employee_id,
       first_name,
       last_name,
       salary,
       CASE WHEN salary >= (SELECT AVG(salary) FROM employees) THEN 'HIGH'
            ELSE 'LOW' END AS salary_status
  FROM employees;


/* 25. Write a query to display the employee id, name (first name and last name), Salary, AvgCompare (salary - the average salary of all employees) and the SalaryStatus column with a title HIGH and LOW respectively for those employees whose salary is more than and less than the average salary of all employees. */

SELECT employee_id,
       first_name,
       last_name,
       salary AS salary_drawn,
       ROUND(salary - (SELECT AVG(salary) FROM employees), 2) AS avg_compare,
       CASE WHEN salary >= (SELECT AVG(salary) FROM employees) THEN 'HIGH'
                 ELSE 'LOW' END AS salary_status
  FROM employees;


/* 26. Write a subquery that returns a set of rows to find all departments that do actually have one or more employees assigned to them. */

SELECT department_name
  FROM departments
  WHERE department_id IN (SELECT DISTINCT department_id
                            FROM employees);


/* 27. Write a query that will identify all employees who work in departments located in the United Kingdom. */

SELECT *
  FROM employees
  WHERE department_id IN (SELECT department_id
                            FROM departments
                            WHERE location_id IN (SELECT location_id
                                                    FROM locations
                                                    WHERE country_id IN (SELECT country_id
                                                                           FROM countries
                                                                           WHERE country_name = 'United Kingdom')));


/* 28. Write a query to identify all the employees who earn more than the average and who work in any of the IT departments. */

SELECT *
  FROM employees
  WHERE salary > (SELECT AVG(salary)
                    FROM employees)
    AND department_id IN (SELECT department_id
                            FROM departments
                            WHERE department_name LIKE ('%IT%'));


/* 29. Write a query to determine who earns more than Mr. Ozer. */

SELECT first_name,
       last_name,
       salary
  FROM employees
  WHERE salary > (SELECT salary
                    FROM employees
                    WHERE last_name = 'Ozer');


/* 30. Write a query to find out which employees have a manager who works for a department based in the US. */

SELECT first_name,
       last_name
  FROM employees
  WHERE manager_id IN (SELECT employee_id
                         FROM employees
                         WHERE department_id IN (SELECT department_id
                                                   FROM departments
                                                   WHERE location_id IN (SELECT location_id
                                                                           FROM locations
                                                                           WHERE country_id = 'US')));


/* 31. Write a query which is looking for the names of all employees whose salary is greater than 50% of their department’s total salary bill. */

SELECT e1.first_name,
       e1.last_name
  FROM employees e1
  WHERE salary > (SELECT SUM(salary)*0.5
                    FROM employees e2
                    WHERE e1.department_id =  e2.department_id);


/* 32. Write a query to get the details of employees who are managers. */

SELECT *
  FROM employees
  WHERE employee_id IN (SELECT manager_id
                          FROM departments);


/* 33. Write a query to get the details of employees who manage a department. */

SELECT * 
  FROM employees 
  WHERE employee_id = ANY (SELECT manager_id
                             FROM departments);


/* 34. Write a query to display the employee id, name (first name and last name), salary, department name and city for all the employees who gets the salary as the salary earn by the employee which is maximum within the joining person January 1st, 2002 and December 31st, 2003. */

SELECT e.employee_id,
       e.first_name,
       e.last_name,
       e.salary,
       d.department_name,
       l.city
  FROM employees e
  INNER JOIN departments d
    ON e.department_id = d.department_id
  INNER JOIN locations l
    ON d.location_id = l.location_id
  WHERE e.salary = (SELECT MAX(salary)
                      FROM employees
                      WHERE hire_date BETWEEN '2002-01-01' AND '2003-12-31');


/* 35. Write a query in SQL to display the department code and name for all departments which located in the city London. */

SELECT department_id,
       department_name
  FROM departments
  WHERE location_id IN (SELECT location_id
                          FROM locations
                          WHERE city = 'London');


/* 36. Write a query in SQL to display the first and last name, salary, and department ID for all those employees who earn more than the average salary and arrange the list in descending order on salary. */

SELECT first_name,
       last_name,
       salary,
       department_id
  FROM employees
  WHERE salary > (SELECT AVG(salary)
		    FROM employees)
  ORDER BY salary DESC;


/* 37. Write a query in SQL to display the first and last name, salary, and department ID for those employees who earn more than the maximum salary of a department which ID is 40. */

SELECT first_name,
       last_name,
       salary,
       department_id
  FROM employees
  WHERE salary > (SELECT MAX(salary)
		    FROM employees
                    WHERE department_id = 40);


/* 38. Write a query in SQL to display the department name and Id for all departments where they located, that Id is equal to the Id for the location where department number 30 is located. */

SELECT department_name,
       department_id
  FROM departments
  WHERE location_id = (SELECT location_id
                         FROM departments 
                         WHERE department_id = 30);


/* 39. Write a query in SQL to display the first and last name, salary, and department ID for all those employees who work in that department where the employee works who hold the ID 201. */

SELECT first_name,
       last_name,
       salary,
       department_id
  FROM employees
  WHERE department_id = (SELECT department_id
		           FROM employees
                           WHERE employee_id = 201);


/* 40. Write a query in SQL to display the first and last name, salary, and department ID for those employees whose salary is equal to the salary of the employee who works in that department which ID is 40. */

SELECT first_name,
       last_name,
       salary,
       department_id
  FROM employees
  WHERE salary IN (SELECT salary
		     FROM employees
                     WHERE department_id = 40);


/* 41. Write a query in SQL to display the first and last name, and department code for all employees who work in the department Marketing. */

SELECT first_name,
       last_name,
       department_id
  FROM employees
  WHERE department_id IN (SELECT department_id
		            FROM departments
                            WHERE department_name = 'Marketing');


/* 42. Write a query in SQL to display the first and last name, salary, and department ID for those employees who earn more than the minimum salary of a department which ID is 40. */

SELECT first_name,
       last_name,
       salary,
       department_id
  FROM employees
  WHERE salary > (SELECT MIN(salary)
		    FROM employees
          	    WHERE department_id = 40);


/* 43. Write a query in SQL to display the full name, email, and hire date for all those employees who was hired after the employee whose ID is 165. */

SELECT CONCAT(first_name, ' ', last_name) AS full_name,
       email,
       hire_date
  FROM employees
  WHERE hire_date > (SELECT hire_date
                       FROM employees
                       WHERE employee_id = 165);


/* 44. Write a query in SQL to display the first and last name, salary, and department ID for those employees who earn less than the minimum salary of a department which ID is 70. */

SELECT first_name,
       last_name,
       salary,
       department_id
  FROM employees
  WHERE salary < (SELECT MIN(salary)
		    FROM employees
          	    WHERE department_id = 70);


/* 45. Write a query in SQL to display the first and last name, salary, and department ID for those employees who earn less than the average salary, and also work at the department where the employee Laura is working as a first name holder. */

SELECT first_name,
       last_name,
       salary,
       department_id
  FROM employees
  WHERE salary < (SELECT AVG(salary)
		    FROM employees)
    AND department_id = (SELECT department_id
                           FROM employees
                           WHERE first_name = 'Laura');


/* 46. Write a query in SQL to display the first and last name, salary, and department ID for those employees whose department is located in the city London. */

SELECT first_name,
       last_name,
       salary,
       department_id 
  FROM employees
  WHERE department_id IN (SELECT department_id
                            FROM departments
                            WHERE location_id IN (SELECT location_id
                                                    FROM locations
                                                    WHERE city = 'London'));


/* 47. Write a query in SQL to display the city of the employee whose ID 134 and works there. */

SELECT city
  FROM locations
  WHERE location_id IN (SELECT location_id
                          FROM departments
                          WHERE department_id IN (SELECT department_id
                                                    FROM employees
                                                    WHERE employee_id = 134));


/* 48. Write a query in SQL to display the the details of those departments which max salary is 7000 or above for those employees who already done one or more jobs. */

SELECT *
  FROM departments
  WHERE department_id IN (SELECT department_id
                            FROM employees
                            WHERE employee_id IN (SELECT employee_id
                                                    FROM job_history
                                                    GROUP BY employee_id
                                                    HAVING COUNT(*) > 1)
                            GROUP BY department_id
                            HAVING MAX(salary) > 7000);


/* 49. Write a query in SQL to display the detail information of those departments which starting salary is at least 8000. */

SELECT *
  FROM departments
  WHERE department_id IN (SELECT department_id
                            FROM employees
                            GROUP BY department_id
                            HAVING MIN(salary) >= 8000);


/* 50. Write a query in SQL to display the full name (first and last name) of manager who is supervising 4 or more employees. */

SELECT CONCAT(first_name, ' ', last_name) AS full_name
  FROM employees
  WHERE employee_id IN (SELECT manager_id
                          FROM employees
                          GROUP BY manager_id
                          HAVING COUNT(*) >= 4);


/* 51. Write a query in SQL to display the details of the current job for those employees who worked as a Sales Representative in the past. */

SELECT *
  FROM jobs
  WHERE job_id IN (SELECT job_id
                     FROM employees
                     WHERE employee_id IN (SELECT employee_id
                                             FROM job_history
                                             WHERE job_id = 'SA_REP'));


/* 52. Write a query in SQL to display all the information about those employees who earn second lowest salary of all the employees. */

SELECT *
  FROM employees
  WHERE salary IN (SELECT MIN(salary)
                     FROM employees
                     WHERE salary > (SELECT MIN(salary)
                                       FROM employees));


/* 53. Write a query in SQL to display the details of departments managed by Susan. */

SELECT *
  FROM departments
  WHERE manager_id IN (SELECT employee_id
                         FROM employees
                         WHERE first_name = 'Susan');


/* 54. Write a query in SQL to display the department ID, full name (first and last name), salary for those employees who is highest salary drawer in a department. */

SELECT department_id,
       CONCAT(first_name, ' ', last_name) AS full_name,
       salary
  FROM employees e
  WHERE salary IN (SELECT MAX(salary)
                     FROM employees
                     WHERE department_id = e.department_id);


/* 55. Write a query in SQL to display all the information of those employees who did not have any job in the past. */

SELECT *
  FROM employees
  WHERE employee_id NOT IN (SELECT employee_id
                              FROM job_history);
