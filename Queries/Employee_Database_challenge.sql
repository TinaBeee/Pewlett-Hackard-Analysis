SELECT e.emp_no, e.first_name, e.last_name, t.title, t.from_data, t.to_date
INTO retirement_titles
FROM employees AS e
INNER JOIN titles AS t
ON e.emp_no = t.emp_no
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (rt.emp_no) rt.emp_no,
rt.first_name,
rt.last_name,
rt.title
INTO unique_titles
FROM retirement_titles AS rt
ORDER BY rt.emp_no, rt.to_date DESC;

SELECT COUNT(ut.title), ut.title
INTO retiring_titles
FROM unique_titles AS ut
GROUP BY ut.title
ORDER BY COUNT DESC;

SELECT DISTINCT ON (e.emp_no) e.emp_no, 
	e.first_name, 
	e.last_name, 
	e.birth_date, 
	de.from_date,
	de.to_date,
	t.title
INTO mentorship_eligibility
FROM employees AS e
INNER JOIN dept_emp AS de
ON e.emp_no = de.emp_no
INNER JOIN titles AS t
ON e.emp_no = t.emp_no
WHERE (de.to_date = '9999-01-01') 
	AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY emp_no;


-- Expanding the birth date range eligibility for the mentorship program
-- to be in line with the number of employees retiring (33,118 employees are retiring)
SELECT DISTINCT ON (e.emp_no) e.emp_no, 
	e.first_name, 
	e.last_name, 
	e.birth_date, 
	de.from_date,
	de.to_date,
	t.title
INTO exp_mentorship_eligibility
FROM employees AS e
INNER JOIN dept_emp AS de
ON e.emp_no = de.emp_no
INNER JOIN titles AS t
ON e.emp_no = t.emp_no
WHERE (de.to_date = '9999-01-01') 
	AND (e.birth_date BETWEEN '1963-05-01' AND '1965-12-31')
ORDER BY emp_no, title;

-- the output with this expanded birth date range are 32,425 employees who'd be
-- eligible for the mentorship program
SELECT COUNT(emp_no) AS "Number of employees"
FROM exp_mentorship_eligibility;


-- Determine which other departments are esp affected
SELECT rpd.count, rpd.dept_no, d.dept_name
INTO retirement_per_dept_name
FROM retirement_per_dept AS rpd
INNER JOIN departments AS d
ON rpd.dept_no = d.dept_no
ORDER BY COUNT DESC;

-- The output shows that the Development, Production and Sales dept are most heavily impacted
SELECT * FROM retirement_per_dept_name