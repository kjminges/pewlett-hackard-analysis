-- Retirement eligibility
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT COUNT(emp_no)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

-- Joining the departments and dept_manager files
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- Employee count by department number
SELECT de.dept_no,
	COUNT(ce.emp_no)
INTO dept_count
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

-- Employee Information: A list of employees containing their unique employee number, their last name, first name, gender, and salary
DROP TABLE emp_info;
SELECT e.emp_no,
	e.last_name,
	e.first_name,
	e.gender,
	s.salary,
	de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON e.emp_no = s.emp_no
INNER JOIN dept_emp as de
ON e.emp_no = de.emp_no
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	AND (de.to_date = '9999-01-01')
ORDER BY e.emp_no;

-- Management: A list of managers for each department, including the department number, name, and the manager's employee number, last name, first name, and the starting and ending employment dates
DROP TABLE manager_info;
SELECT dm.emp_no,
	e.last_name,
	e.first_name,
	dm.dept_no,
	d.dept_name,
	dm.from_date,
	dm.to_date
INTO manager_info
FROM dept_manager as dm
	INNER JOIN employees as e
		ON (dm.emp_no = e.emp_no)
	INNER JOIN departments as d
		ON (dm.dept_no = d.dept_no)
ORDER BY dm.emp_no;

-- Department Retirees: An updated current_emp list that includes everything it currently has, but also the employee's departments
DROP TABLE dept_info;
SELECT ce.emp_no,
	ce.last_name,
	ce.first_name,
	d.dept_name
INTO dept_info
FROM current_emp as ce
	LEFT JOIN dept_emp as de
		ON (ce.emp_no = de.emp_no)
	LEFT JOIN departments as d
		on (de.dept_no = d.dept_no)	
ORDER BY ce.emp_no;