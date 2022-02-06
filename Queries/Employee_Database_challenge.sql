-- List of eployees, with career job titles, scheduled to retire in the comming years. This uses an employee specific look-up (ie left joins between the Employees and Titles tables, respecitvely).
-- DROP TABLE retirement_titles;
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	t.title,
	t.from_date,
	t.to_date
INTO retirement_titles
FROM employees AS e
	LEFT JOIN titles AS t
	ON e.emp_no = t.emp_no
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31') 
ORDER BY e.emp_no;
SELECT * FROM retirement_titles;

-- Remove old job titles to create a list of current employees who will be retiring soon and their current job title.   
-- DROP TABLE unique_titles;
SELECT DISTINCT ON (e.emp_no) e.emp_no,
	e.first_name,
	e.last_name,
	t.title
INTO unique_titles
FROM employees AS e
	LEFT JOIN titles AS t
	ON e.emp_no = t.emp_no
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31') 
	AND (t.to_date = '9999-01-01')
ORDER BY e.emp_no, t.from_date DESC;
SELECT * FROM unique_titles;

-- Summarize the total number of employees scheduled to retire soon by current job title (ie their expected title at retirement). 
-- DROP TABLE retiring_titles;
SELECT (CASE GROUPING(title) WHEN 1 THEN 'Total' ELSE title END) AS "Recent Job Title",
	COUNT(emp_no) AS "Title Count"
INTO retiring_titles
FROM unique_titles
GROUP BY ROLLUP(title)
ORDER BY COUNT(emp_no) DESC;
SELECT * FROM retiring_titles;

-- List of eployees, with current career job titles, who are fit for the mentorship program (ie 10 years younger than the youngest potential member of the silver wave). This uses an employee specific look-up (ie left joins between the Employees and Titles and Department Employees tables, respecitvely).
-- DROP TABLE mentorship_eligibilty;
SELECT DISTINCT ON(e.emp_no) e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	t.title,
	de.from_date,
	de.to_date
INTO mentorship_eligibilty
FROM employees AS e
	LEFT JOIN titles AS t
	ON e.emp_no = t.emp_no
	LEFT JOIN dept_emp AS de
	ON e.emp_no = de.emp_no
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31') 
	AND (t.to_date = '9999-01-01')
ORDER BY e.emp_no, de.from_date DESC;
SELECT * FROM mentorship_eligibilty;

-- Summarize the total number of employees that could be mentored based on current job title (ie their expected title at the time of the silver wave). 
-- DROP TABLE mentorship_titles;
SELECT (CASE GROUPING(title) WHEN 1 THEN 'Total' ELSE title END) AS "Recent Job Title",
	COUNT(emp_no) AS "Title Count"
INTO mentorship_titles
FROM mentorship_eligibilty
GROUP BY ROLLUP(title)
ORDER BY COUNT(emp_no) DESC;
SELECT * FROM mentorship_titles;