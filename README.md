## Employee Data Analysis
Analysis of employee data to prepare for retirement wave and determine retirement eligibility 

### Resources
- Data Sources: departments.csv, dept_emp.csv, dept_manager.csv, employees.csv, titles.csv, salaries.csv
- Software: PostgreSQL 11, pgAdmin 4, Visual Studio Code

## Overview of the Analysis
- Provided with six separate csv files containing information about the companies' employees, their departments, birth dates, salaries, job titles, starting and end
  dates
- Asked to determine the number of employees eligible for retirement and create separate tables for individual metrics. The follwing is a selection of analyses:

- Analysis included determining the employees eligible for retirement by date of birth and hire date, and filter out current employees
  
  <img src="https://user-images.githubusercontent.com/90064437/144763151-042eea33-30bc-48fa-a16f-ce2ba48726e3.png" width="400">  
  
- Determining retirement-eligible managers by department:

  <img src="https://user-images.githubusercontent.com/90064437/144763094-26201261-d1e5-44bb-aed2-b02a1bfabb21.png" width="500">

- Determining the number of retirement-eligible employees for specific departments, such as the sales department:

  <img src="https://user-images.githubusercontent.com/90064437/144763050-44a4a336-38de-4ecb-9e3a-5f4fe3f0108b.png" width="500">

- Determining the employee names and their job positions/titles eligible for retirement:
  - Using 
    `SELECT e.emp_no, e.first_name, e.last_name, t.title, t.from_data, t.to_date
    INTO retirement_titles
    FROM employees AS e
    INNER JOIN titles AS t
    ON e.emp_no = t.emp_no
    WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
    ORDER BY e.emp_no;`
    
  - Provided a summary table that included employement-eligible employees with their job titles:
  
    <img src ="https://user-images.githubusercontent.com/90064437/144762862-2b32029b-6820-4632-a453-c5cfddb2baef.png" width="500">

- Removing duplicate rows to only get an employees' most recent job title using `DISTINCT ON()`, then adding a counter to the job titles of employees who will be
  eligible for retirement:
  
    <img src="https://user-images.githubusercontent.com/90064437/144763239-9fc56159-1b0a-424a-ac9a-6447d7791469.png" width="300">
    
- The employer considered a mentorship scheme to ease the transition of employees retiring and train new hires. Determining mentorship eligibility for older
  employees born in 1965 to become mentors using:
  `SELECT DISTINCT ON (e.emp_no) e.emp_no, 
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
  ORDER BY emp_no;`
  
  <img src="https://user-images.githubusercontent.com/90064437/144763601-b11cb37e-4c00-450e-b4b2-e26bc0cacc37.png" width="500">


### Summary
- How many roles will need to be filled as the "silver tsunami" begins to make an impact?
  - Using `SELECT COUNT(emp_no) AS "Number of employees" FROM current_emp;` shows that a total of 33,118 current employees will be eligible for retirement soon
    (i.e. those employees are born between Jan 1, 1952 and Dec 31, 1955)
    
- Are there enough qualified, retirement-ready employees in the departments to mentor the next generation of Pewlett Hackard employees?
  - Using `SELECT COUNT(emp_no) AS "Number of employees" FROM mentorship_eligibility;` shows that only 1,549 current employees would be eligible as mentors
    given the current selection criteria of the date of birth being between Jan 1, 1965 and Dec 31, 1965; under that selection, there are not enough mentors for 
    new hires

- What other analyses can be done?
  - Expanding the mentor eligibility like so `SELECT DISTINCT ON (e.emp_no) e.emp_no, 
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
ORDER BY emp_no, title;` and then using the `SELECT COUNT(emp_no) AS "Number of employees"
FROM exp_mentorship_eligibility;` would provide the company with 32,425 eligible mentors

  - Determining which other departments in the company are particularly affected by the looming "silver tsunami" using:
    `SELECT rpd.count, rpd.dept_no, d.dept_name
INTO retirement_per_dept_name
FROM retirement_per_dept AS rpd
INNER JOIN departments AS d
ON rpd.dept_no = d.dept_no
ORDER BY COUNT DESC;`
  
  The output shows us that the Development, Production and Sales Departments will see the highest number of retirements, making it worthwhile to taylor the
  mentorship program to those units:
  
  <img src="https://user-images.githubusercontent.com/90064437/144764028-6e077c29-1e3d-43c6-927a-5d7b23dfbd37.png" width="400">
