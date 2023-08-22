***** BASIC QUERIES *****

SELECT * FROM COMPANY_DIVISIONS
LIMIT 5

SELECT * FROM COMPANY_REGIONS
LIMIT 5

SELECT * FROM STAFF 
LIMIT 5


-- How many employees in the company? --
SELECT COUNT(*) FROM STAFF


-- How many employees are in each department? --
SELECT DEPARTMENT, COUNT(*)
FROM STAFF
GROUP BY DEPARTMENT
ORDER BY 1


-- How many distinct departments? --
SELECT DISTINCT(DEPARTMENT) FROM COMPANY_DIVISIONS

/* Also could use distinct from staff table but the company divisions table is where the
-- departments are listed so it's safer that way

SELECT DISTINCT(DEPARTMENT) FROM STAFF */


-- What are the highest and lowest salaries in the company?
SELECT 
	MAX(SALARY) AS MAX_SALARY, 
	MIN(SALARY) AS MIN_SALARY
FROM STAFF


-- What is salary distribution by gender? --
-- Females make more money on average by $94
SELECT 
	GENDER, 
	MAX(SALARY) AS MAX_SALARY, 
	MIN(SALARY) AS MIN_SALARY, 
	ROUND(AVG(SALARY), 2) AS AVG_SALARY
FROM STAFF
GROUP BY GENDER

-- What is the salary distribution by department? -- 
-- Jewelry department has the lowest average salary while outdoors has the highest
SELECT 
	DEPARTMENT, 
	MAX(SALARY) AS MAX_SALARY,
	MIN(SALARY) AS MIN_SALARY,
	ROUND(AVG(SALARY), 2) AS AVG_SALARY 
FROM STAFF
GROUP BY DEPARTMENT
ORDER BY 4

-- Spread of salary around average of each department --
-- Outdoors has the highest averager salary and also within close range of the average 
SELECT 
	DEPARTMENT, 
	MIN(SALARY) As MIN_SALARY, 
	MAX(SALARY) AS MAX_SALARY, 
	ROUND(AVG(SALARY), 2) AS AVG_SALARY,
	ROUND(STDDEV_POP(SALARY), 2) AS STD_DEV_SALARY,
	COUNT(*) AS EMP
FROM STAFF
GROUP BY DEPARTMENT
ORDER BY 5 DESC


/* Outdoors has the highest average salary with lowest dispersion, Healthy has the highest dispersion
with a lower average salary than Outdoors, and with similar number of employees... let's investigate */

-- Let's write a query to look at the Health and Outdoor departments
SELECT * FROM STAFF WHERE DEPARTMENT IN ('Health', 'Outdoors')
ORDER BY Department


/* Create Views */

/* Now let's create categories for salary to see the number of higher/middle/lower earners for the
Health and Outdoors departments */


CREATE OR REPLACE VIEW OUTDOORS_DEPT_EARNING_GROUP 
AS 
	SELECT
		CASE 
			WHEN SALARY >= 100000 THEN 'High Earner'
			WHEN SALARY >= 50000 AND SALARY < 100000 THEN 'Middle Earner' 
			ELSE 'Low Earner'
		END AS EARNING_GROUP
	FROM STAFF 
	WHERE DEPARTMENT = 'Outdoors'
	

  
CREATE OR REPLACE VIEW HEALTH_DEPT_EARNING_GROUP 
AS 
	SELECT
		CASE 
			WHEN SALARY >= 100000 THEN 'High Earner' 
			WHEN SALARY >= 50000 AND SALARY < 100000 THEN 'Middle Earner'
			ELSE 'Low Earner'
		END AS EARNING_GROUP
	FROM STAFF 
	WHERE DEPARTMENT = 'Health'
		

-- Take a look at the number of earners per earning group based on the views above -- 

SELECT
	EARNING_GROUP, 
	COUNT(*)
FROM OUTDOORS_DEPT_EARNING_GROUP
GROUP BY 1

SELECT
	EARNING_GROUP, 
	COUNT(*)
FROM HEALTH_DEPT_EARNING_GROUP
GROUP BY 1


/* The Outdoors department has 10 more "High Earners" than the Health department which explains why 
Outdoors department has a lower dispersion than the Health department */





