/* Filtering, Joins, Aggregations */

-- FILTERING -- 

SELECT * FROM COMPANY_DIVISIONS
SELECT * FROM COMPANY_REGIONS
SELECT * FROM STAFF

-- Display all employees in the Computers department
SELECT * FROM STAFF WHERE DEPARTMENT = 'Computers'

-- Display all 'female' employees in Computers department
SELECT * FROM STAFF WHERE DEPARTMENT = 'Computers' AND GENDER = 'Female'

-- Display Display all 'female' employees in Computers department and have 'Manager' in their job title
SELECT * FROM STAFF WHERE DEPARTMENT = 'Computers' AND GENDER = 'Female'
AND JOB_TITLE LIKE '%Manager%'

-- Display all employees with last names ('Smith', 'Williams', or 'Johnson') AND have manager in their job title
SELECT * FROM STAFF
WHERE LAST_NAME IN ('Smith', 'Williams', 'Johnson') AND JOB_TITLE LIKE '%Manager%'

-- Display employees who have a last name shorter than 6 letters
SELECT * FROM STAFF WHERE LENGTH(LAST_NAME) < 6

-- Display salaries between 30,000 and 60,000
SELECT * FROM STAFF WHERE SALARY BETWEEN 30000 AND 60000 ORDER BY SALARY

-- Display employees who started work between 2007 and 2010
SELECT
	ID, 
	LAST_NAME,
	EMAIL, 
	START_DATE 
FROM STAFF WHERE START_DATE >= to_date('2007-01-01','YYYY-MM-DD')
AND START_DATE <= to_date('2010-12-31','YYYY-MM-DD')
ORDER BY START_DATE


/* JOINS */
-- Join the company regions and staff to show employees with their region/country
SELECT
	S.ID, 
	S.LAST_NAME,
	S.JOB_TITLE,
	S.REGION_ID,
	CR.REGION_ID,
	CR.COMPANY_REGIONS,
	CR.COUNTRY
FROM STAFF S INNER JOIN COMPANY_REGIONS CR
ON S.REGION_ID = CR.REGION_ID

-- This query returns 953 employees; where are the other 47?
SELECT 
	S.LAST_NAME, 
	S.DEPARTMENT, 
	CD.COMPANY_DIVISION
FROM STAFF S
INNER JOIN COMPANY_DIVISIONS CD
ON CD.DEPARTMENT = S.DEPARTMENT

-- Perform a Left Join to grab all rows staff and matching rows in Company Divisions
-- This query returns 1000 but 47 are missing company division values
SELECT 
	S.LAST_NAME, 
	S.DEPARTMENT, 
	CD.COMPANY_DIVISION
FROM STAFF S
LEFT JOIN COMPANY_DIVISIONS CD
ON CD.DEPARTMENT = S.DEPARTMENT

-- Let's see who those 47 people are?
SELECT 
	S.LAST_NAME, 
	S.DEPARTMENT, 
	CD.COMPANY_DIVISION
FROM STAFF S
LEFT JOIN COMPANY_DIVISIONS CD
ON CD.DEPARTMENT = S.DEPARTMENT
WHERE COMPANY_DIVISION IS NULL



/* AGGREGATIONS */

-- Let's create a view and look at staff number by region, divison, etc.

CREATE OR REPLACE VIEW staff_reg_div_country
AS
	SELECT
		S.*,
		CR.COMPANY_REGIONS,
		CR.COUNTRY, 
		CD.COMPANY_DIVISION
	FROM STAFF S
	LEFT JOIN COMPANY_REGIONS CR ON S.REGION_ID = CR.REGION_ID
	LEFT JOIN COMPANY_DIVISIONS CD ON CD.DEPARTMENT = S.DEPARTMENT
	
-- Look at newly created view
SELECT * FROM STAFF_REG_DIV_COUNTRY

-- Display number of employees per region
SELECT COMPANY_REGIONS, COUNT(*) AS EMPLOYEES
FROM STAFF_REG_DIV_COUNTRY
GROUP BY 1
ORDER BY 2

-- NOTE: Can also replace company_regions with country or company_division

-- Let's use a handy Group By subclause to group by multiple columns
SELECT
	COMPANY_REGIONS, 
	COMPANY_DIVISION,
	COUNT(*) AS NUM_EMP
FROM STAFF_REG_DIV_COUNTRY
GROUP BY 
	GROUPING SETS(COMPANY_REGIONS, COMPANY_DIVISION)
ORDER BY 1, 2

-- ROLLUP -- 
-- ROLLUP provides grand total and sub-totals for each column combo listed
SELECT
	COALESCE(COUNTRY, 'Country Total') AS Country,
	COALESCE(COMPANY_REGIONS, 'Region Total') AS Company_region,
	--COMPANY_DIVISION,
	COUNT(*) AS NUM_EMP
FROM STAFF_REG_DIV_COUNTRY
GROUP BY ROLLUP(COUNTRY, COMPANY_REGIONS)

-- CUBE -- 
-- CUBE is similar to ROLLUP with all permutations of columns listed
SELECT
	COUNTRY,
	COMPANY_REGIONS, 
	--COMPANY_DIVISION,
	COUNT(*) AS NUM_EMP
FROM STAFF_REG_DIV_COUNTRY
GROUP BY CUBE(COUNTRY, COMPANY_REGIONS)
ORDER BY 1, 3 DESC

-- Let's add some complexity to see how these group by sub-clauses can perform
-- The first sums the salary for each country c1, c2, c3 combination

SELECT
	COALESCE(COUNTRY, 'Country Total') AS Country,
	COALESCE(COMPANY_REGIONS, 'Region Total') AS Company_region,
	COALESCE(GENDER, 'ALL GENDER') AS gender,
	--COMPANY_DIVISION,
	ROUND(SUM(SALARY), 2) AS AVG_SALARY
FROM STAFF_REG_DIV_COUNTRY
GROUP BY ROLLUP(COUNTRY, COMPANY_REGIONS, GENDER)

-- This query performs similarly with the addition of permutations

SELECT
	COALESCE(COUNTRY, 'Country Total') AS Country,
	COALESCE(COMPANY_REGIONS, 'Region Total') AS Company_region,
	COALESCE(GENDER, 'ALL GENDER') AS gender,
	--COMPANY_DIVISION,
	ROUND(SUM(SALARY), 2) AS AVG_SALARY
FROM STAFF_REG_DIV_COUNTRY
GROUP BY CUBE(COUNTRY, COMPANY_REGIONS, GENDER)
ORDER BY 1





