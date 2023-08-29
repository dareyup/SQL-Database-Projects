/* Window Functions : Allow you to perform operations on a set of rows related to the current row of processing */

-- OVER (PARTITION BY): 

-- Let's look at average salary by department vs each indiviual salary
SELECT
	LAST_NAME,
	DEPARTMENT,
	SALARY,
	ROUND(AVG(SALARY) OVER (PARTITION BY DEPARTMENT), 2) AS AVG_SALARY
FROM STAFF


SELECT
	LAST_NAME,
	DEPARTMENT,
	SALARY,
	ROUND(AVG(SALARY) OVER (PARTITION BY DEPARTMENT), 2) AS AVG_SALARY
FROM STAFF

-- Let's look at years at company of each individual vs avg years and max years worked
-- The average years worked is 15 and max years is 23 compared to each employee. 

WITH YEARS_AT_COMPANY AS (
	SELECT 
		ID, 
		LAST_NAME,
		START_DATE,
		CURRENT_DATE, 
 		DATE_PART('YEAR', CURRENT_DATE) - DATE_PART('YEAR', START_DATE) AS YEARS_WORKED
	FROM STAFF
)
SELECT 
	*, 
	FLOOR(AVG(YEARS_WORKED) OVER ()) AS AVG_YRS_WORKED,
	MAX(YEARS_WORKED) OVER () AS MAX_YEARS_WORKED
FROM YEARS_AT_COMPANY


/* RANK: does what it says and ranks rows based on partition -- duplicate rank for sameness */
-- Rank employees years worked in descending order

/* CREATE OR REPLACE VIEW yrs_worked 
AS 
SELECT 
	ID, 
	LAST_NAME,
	START_DATE,
	CURRENT_DATE, 
 	DATE_PART('YEAR', CURRENT_DATE) - DATE_PART('YEAR', START_DATE) AS YEARS_WORKED, 
	DEPARTMENT
FROM STAFF
*/

-- As you can see, employees are ranked but notice for those who worked the same amount years there is a duplicate rank
SELECT 
	*,
	RANK() OVER (PARTITION BY DEPARTMENT ORDER BY YEARS_WORKED DESC)
FROM YRS_WORKED


-- DENSE_RANK: Same as rank but with consecutive ranks for sameness per partition
-- Notice the 2nd ranked employees for this query, they were ranked 3rd with RANK()
SELECT 
	*,
	DENSE_RANK() OVER (PARTITION BY DEPARTMENT ORDER BY YEARS_WORKED DESC)
FROM YRS_WORKED


-- LAG(): Allows access to previous row for comparison to current row
-- Displays years worked for each employee compared to the next highest years worked for the 'Automotive' department
SELECT 
	*,
	LAG(YEARS_WORKED) OVER (PARTITION BY DEPARTMENT ORDER BY YEARS_WORKED )
FROM YRS_WORKED
WHERE DEPARTMENT = 'Automotive'


-- LEAD(): Allows access to the next for comparison to current row
-- Displays years worked for each employee compared to the next highest years worked for the 'Automotive' department
-- Notice how the 'lead' column is the next persons years_worked
SELECT 
	*,
	LEAD(YEARS_WORKED) OVER (PARTITION BY DEPARTMENT ORDER BY YEARS_WORKED)
FROM YRS_WORKED
WHERE DEPARTMENT = 'Automotive'



-- PERCENT_RANK(): Caluclates relative percentile rank for set of values 
-- Display percentile rank for years worked in the 'Sports' department
SELECT
	*, 
	PERCENT_RANK() OVER (ORDER BY YEARS_WORKED)
FROM YRS_WORKED
WHERE DEPARTMENT = 'Sports'








