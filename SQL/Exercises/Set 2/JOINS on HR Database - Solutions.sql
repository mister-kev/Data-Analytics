/* 1. Write a query in SQL to display the first name, last name, department number, and department name for each employee. */

SELECT e.first_name,
       e.last_name,
       e.department_id,
       d.department_name
  FROM employees e
  INNER JOIN departments d
    ON e.department_id = d.department_id;


/* 2. Write a query in SQL to display the first and last name, department, city, and state province for each employee. */

SELECT e.first_name,
       e.last_name,
       d.department_name,
       l.city,
       l.state_province
  FROM employees e
  INNER JOIN departments d
    ON e.department_id = d.department_id
  INNER JOIN locations l
    ON d.location_id = l.location_id;


/* 3. Write a query in SQL to display the first name, last name, salary, and job grade for all employees. */

SELECT e.first_name,
       e.last_name,
       e.salary,
       j.grade_level
  FROM employees e
  INNER JOIN job_grades j
    ON e.salary BETWEEN j.lowest_sal AND j.highest_sal;


/* 4. Write a query in SQL to display the first name, last name, department number and department name, for all employees for departments 80 or 40. */

SELECT e.first_name,
       e.last_name,
       d.department_id,
       d.department_name
  FROM employees e
  INNER JOIN departments d
    ON e.department_id = d.department_id
      AND d.department_id IN (80, 40)
  ORDER BY e.last_name;


/* 5. Write a query in SQL to display those employees who contain a letter z to their first name and also display their last name, department, city, and state province. */

SELECT e.first_name,
       e.last_name,
       d.department_name,
       l.city,
       l.state_province
  FROM employees e
  INNER JOIN departments d
    ON e.department_id = d.department_id
  INNER JOIN locations l
    ON d.location_id = l.location_id
  WHERE e.first_name LIKE '%z%';


/* 6. Write a query in SQL to display all departments including those where does not have any employee. */

SELECT e.first_name,
       e.last_name,
       d.department_id,
       d.department_name
  FROM departments d
  LEFT JOIN employees e
    ON d.department_id = e.department_id;


/* 7. Write a query in SQL to display the first and last name and salary for those employees who earn less than the employee earn whose number is 182. */

SELECT e1.first_name,
       e1.last_name,
       e1.salary
  FROM employees e1
  INNER JOIN employees e2
    ON e1.salary < e2.salary
      AND e2.employee_id = 182;


/* 8. Write a query in SQL to display the first name of all employees including the first name of their manager. */

SELECT e1.first_name AS "employee_name",
       e2.first_name AS "manager_name"
  FROM employees e1
  INNER JOIN employees e2
    ON e1.manager_id = e2.employee_id;


/* 9. Write a query in SQL to display the department name, city, and state province for each department. */

SELECT d.department_name,
       l.city,
       l.state_province
  FROM departments d
  INNER JOIN locations l
    ON d.location_id = l.location_id;


/* 10. Write a query in SQL to display the first name, last name, department number and name, for all employees who have or have not any department. */

SELECT e.first_name,
       e.last_name,
       d.department_id,
       d.department_name
  FROM employees e
  LEFT JOIN departments d
    ON e.department_id = d.department_id;


/* 11. Write a query in SQL to display the first name of all employees and the first name of their manager including those who does not working under any manager. */

SELECT e1.first_name AS "employee_name",
       e2.first_name AS "manager_name"
  FROM employees e1
  LEFT JOIN employees e2
    ON e1.manager_id = e2.employee_id;


/* 12. Write a query in SQL to display the first name, last name, and department number for those employees who works in the same department as the employee who holds the last name as Taylor. */

SELECT e1.first_name,
       e1.last_name,
       e1.department_id
  FROM employees e1
  INNER JOIN employees e2
    ON e1.department_id = e2.department_id
      AND e2.last_name = 'Taylor';


/* 13. Write a query in SQL to display the job title, department name, full name (first and last name ) of employee, and starting date for all the jobs which started on or after 1st January, 1993 and ending with on or before 31 August, 1997 */

SELECT j.job_title,
       d.department_name,
       CONCAT(e.first_name, ' ', e.last_name) AS full_name,
       jh.start_date
  FROM employees e
  INNER JOIN job_history jh
    ON e.employee_id = jh.employee_id
      AND jh.start_date BETWEEN '1993-01-01' AND '1997-08-31'
  INNER JOIN jobs j
    ON jh.job_id = j.job_id
  INNER JOIN departments d
    ON jh.department_id = d.department_id;


/* 14. Write a query in SQL to display job title, full name (first and last name ) of employee, and the difference between maximum salary for the job and salary of the employee. */

SELECT j.job_title,
       CONCAT(e.first_name, ' ', e.last_name) AS full_name,
       (j.max_salary - e.salary) AS salary_diff
  FROM employees e
  INNER JOIN jobs j
    ON e.job_id = j.job_id;

-- Note: This also works using a NATURAL JOIN which creates an implicit join based on the common columns in the two tables being joined.

SELECT j.job_title,
       CONCAT(e.first_name, ' ', e.last_name) AS full_name,
       (j.max_salary - e.salary) AS salary_diff
  FROM employees e
  NATURAL INNER JOIN jobs j;


/* 15. Write a query in SQL to display the name of the department, average salary and number of employees working in that department who got commission. */

SELECT d.department_name,
       AVG(e.salary),
       COUNT(commission_pct)
  FROM employees e
  JOIN departments d
    ON e.department_id = d.department_id
  GROUP BY d.department_name;


/* 16. Write a query in SQL to display the full name (first and last name ) of employees, job title and the salary differences to their own job for those employees who is working in the department ID 80. */

SELECT CONCAT(e.first_name, ' ', e.last_name) AS full_name,
       j.job_title,
       (j.max_salary - e.salary) AS salary_diff
  FROM employees e
  INNER JOIN jobs j
    ON e.job_id = j.job_id
      WHERE e.department_id = 80;


/* 17. Write a query in SQL to display the name of the country, city, and the departments which are running there. */

SELECT c.country_name,
       l.city,
       d.department_name
  FROM countries c
  INNER JOIN locations l
    ON c.country_id = l.country_id
  INNER JOIN departments d
    ON l.location_id = d.location_id;

-- Note: This also works using JOIN and USING on the common columns.

SELECT c.country_name,
       l.city,
       d.department_name
  FROM countries c
  INNER JOIN locations l USING (country_id) 
  INNER JOIN departments d USING (location_id);


/* 18. Write a query in SQL to display department name and the full name (first and last name) of the manager. */

SELECT d.department_name,
       CONCAT(e.first_name, ' ', e.last_name) AS full_name
  FROM departments d
  INNER JOIN employees e
    ON d.manager_id = e.employee_id;


/* 19. Write a query in SQL to display job title and average salary of employees. */

SELECT j.job_title,
       AVG(e.salary)
  FROM employees e
  INNER JOIN jobs j
    ON e.job_id = j.job_id
  GROUP BY j.job_title;


/* 20. Write a query in SQL to display the details of jobs which was done by any of the employees who is presently earning a salary on and above 12000. */

SELECT jh.*
  FROM employees e
  INNER JOIN job_history jh
    ON e.employee_id = jh.employee_id
      WHERE salary >= 12000.00;


/* 21. Write a query in SQL to display the country name, city, and number of those departments where at least 2 employees are working. */

SELECT c.country_name,
       l.city,
       COUNT(d.department_id)
  FROM countries c
  INNER JOIN locations l
    ON c.country_id = l.country_id
  INNER JOIN departments d
     ON l.location_id = d.location_id
  WHERE d.department_id IN (SELECT e.department_id
                              FROM employees e
                              GROUP BY e.department_id 
                              HAVING COUNT(e.department_id) >= 2)
  GROUP BY c.country_name, l.city;


/* 22. Write a query in SQL to display the department name, full name (first and last name) of manager, and their city.  */

SELECT d.department_name,
       CONCAT(e.first_name, ' ', e.last_name) AS full_name,
       l.city
  FROM employees e
  INNER JOIN departments d
    ON e.employee_id = d.manager_id
  INNER JOIN locations l
    ON d.location_id = l.location_id;


/* 23. Write a query in SQL to display the employee ID, job name, number of days worked in for all those jobs in department 80. */

SELECT jh.employee_id,
       j.job_title,
       (jh.end_date - jh.start_date) AS num_days
  FROM jobs j
  INNER JOIN job_history jh
    ON j.job_id = jh.job_id
      WHERE jh.department_id = 80;

-- Note: This also works using a NATURAL JOIN which creates an implicit join based on the common columns in the two tables being joined.

SELECT jh.employee_id,
       j.job_title,
       (jh.end_date - jh.start_date) AS num_days
  FROM jobs j
  NATURAL INNER JOIN job_history jh
  WHERE jh.department_id = 80;


/* 24. Write a query in SQL to display the full name (first and last name), and salary of those employees who working in any department located in London. */

SELECT CONCAT(e.first_name, ' ', e.last_name) AS full_name,
       e.salary
  FROM employees e
  INNER JOIN departments d
    ON e.department_id = d.department_id
  INNER JOIN locations l
    ON d.location_id = l.location_id
      WHERE l.city = 'London';


/* 25. Write a query in SQL to display full name(first and last name), job title, starting and ending date of last jobs for those employees with worked without a commission percentage. */

SELECT CONCAT(e.first_name, ' ', e.last_name) AS full_name,
       j.job_title,
       jh.*
  FROM employees e
  INNER JOIN (SELECT MAX(start_date) AS starting_date,
                     MAX(end_date) AS ending_date,
                     employee_id
                FROM job_history
                GROUP BY employee_id) jh
    ON e.employee_id = jh.employee_id
  INNER JOIN jobs j
    ON e.job_id = j.job_id
      WHERE e.commission_pct = 0;


/* 26. Write a query in SQL to display the department name and number of employees in each of the department. */

SELECT d.department_name,
       COUNT(e.employee_id) AS num_employees
  FROM departments d
  INNER JOIN employees e
    ON d.department_id = e.department_id
  GROUP BY d.department_name;


/* 27. Write a query in SQL to display the full name (first and last name) of employee with ID and name of the country presently where (s)he is working. */

SELECT CONCAT(e.first_name, ' ', e.last_name) AS full_name,
       e.employee_id,
       c.country_name
  FROM employees e
  INNER JOIN departments d
    ON e.department_id = d.department_id
  INNER JOIN locations l
    ON d.location_id = l.location_id
  INNER JOIN countries c
    ON l.country_id = c.country_id;
