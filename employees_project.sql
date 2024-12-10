use employees;

-- BASIC 
-- 1. Retrieve a list with all female employees whose first name is either Kellie or Aruna.
SELECT 
    *
FROM
    employees
WHERE
    (first_name = 'Kellie'
        OR first_name = 'Aruna')
        AND gender = 'F';

-- 2. List all employees along with their department names
SELECT 
    e.emp_no, e.first_name, e.last_name, e.gender, d.dept_name
FROM
    employees e
        JOIN
    dept_emp de ON de.emp_no = e.emp_no
        JOIN
    departments d ON d.dept_no = de.dept_no
ORDER BY e.emp_no;

-- 3. Find employees whose salary is above the average salary of all employees.
SELECT DISTINCT
    e.emp_no, e.first_name, e.last_name
FROM
    employees e
        JOIN
    salaries s ON s.emp_no = e.emp_no
WHERE
    s.salary > (SELECT 
            AVG(salary)
        FROM
            salaries); 

-- INTERMEDIATE
-- 4. Rank employees based on their salary (highest salary gets rank 1).
SELECT emp_no, salary, 
rank() OVER w AS rank_num
FROM salaries
WINDOW w AS (PARTITION BY emp_no ORDER BY salary DESC);

-- 5. Identify employees who are managers
SELECT 
    *
FROM
    emp_manager;
select e2.* from 
emp_manager as e1
join emp_manager as e2 on e1.emp_no = e2.manager_no;

-- 6. Extract the information about all department managers who were hired between the 1st of January 1990 and the 1st of January 1995.
SELECT 
    *
FROM
    dept_manager
WHERE
    emp_no IN (SELECT 
            emp_no
        FROM
            employees
        WHERE
            hire_date BETWEEN '1990-01-01' AND '1995-01-01');

-- DIFFICULT
-- 7. find out how many employees never signed a contract with a salary value higher than or equal to the all-time company salary average.
WITH cte AS (
SELECT AVG(salary) AS avg_salary FROM salaries)
SELECT
	SUM(CASE WHEN s.salary < c.avg_salary THEN 1 ELSE 0 END) AS no_salaries_below_avg,
	COUNT(s.salary) AS no_of_salary_contracts
FROM salaries s JOIN employees e ON s.emp_no = e.emp_no JOIN cte c;

-- 8. Find the cumulative salary of employees within each department, ordered by salary.
select e.emp_no, e.first_name, e.last_name, s.salary, 
sum(s.salary) over(partition by e.emp_no order by s.salary) as cumulative_salary
from employees e
join salaries s on s.emp_no = e.emp_no;

-- 9. Write a query that ranks the salary values in descending order of all contracts signed by employees numbered between 10500 and 10600 inclusive.
SELECT e.emp_no,
    RANK() OVER w as employee_salary_ranking,
    s.salary
FROM
	employees e
JOIN
    salaries s ON s.emp_no = e.emp_no
WHERE e.emp_no BETWEEN 10500 AND 10600
WINDOW w as (PARTITION BY e.emp_no ORDER BY s.salary DESC);