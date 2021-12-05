SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

SELECT first_name, last_name
FROM employees 
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

SELECT first_name, last_name
FROM employees 
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

SELECT first_name, last_name
FROM employees 
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

SELECT first_name, last_name
FROM employees 
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;

SELECT d.dept_name, m.emp_no, m.from_date, m.to_date
FROM departments as d
INNER JOIN dept_manager as m
ON d.dept_no = m.dept_no;

SELECT r.emp_no, r.first_name, r.last_name, d.to_date
INTO current_emp
FROM retirement_info as r
LEFT JOIN dept_emp as d ON
r.emp_no = d.emp_no
WHERE d.to_date = ('9999-01-01');

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
INTO retirement_per_dept
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM salaries
ORDER BY to_date DESC;

SELECT e.emp_no, e.first_name, e.last_name, e.gender, s.salary, de.to_date
INTO emp_info
FROM employees AS e
INNER JOIN salaries AS s
ON e.emp_no = s.emp_no
INNER JOIN dept_emp AS de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	 AND (de.to_date = '9999-01-01');

SELECT dm.dept_no, 
	d.dept_name, 
	dm.emp_no, 
	ce.first_name, 
	ce.last_name,
	dm.from_date,
	dm.to_date
INTO manager_info
FROM dept_manager AS dm
INNER JOIN departments AS d
ON dm.dept_no = d.dept_no
INNER JOIN current_emp AS ce
ON dm.emp_no = ce.emp_no;

SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name
INTO dept_info
FROM current_emp AS ce
INNER JOIN dept_emp AS de
ON ce.emp_no = de.emp_no
INNER JOIN departments AS d
ON de.dept_no = d.dept_no;

SELECT ce.emp_no, ce.first_name, ce.last_name, d.dept_name
INTO sales_info
FROM current_emp AS ce
INNER JOIN dept_emp AS de
ON ce.emp_no = de.emp_no
INNER JOIN departments as d
ON de.dept_no = d.dept_no
WHERE d.dept_no = ('d007');

SELECT ce.emp_no, ce.first_name, ce.last_name, d.dept_name
INTO sales_dev_info
FROM current_emp AS ce
INNER JOIN dept_emp AS de
ON ce.emp_no = de.emp_no
INNER JOIN departments as d
ON de.dept_no = d.dept_no
WHERE d.dept_no IN ('d007', 'd005');