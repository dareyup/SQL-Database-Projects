--- Data Manipulation ---


/* STRING FUNCTIONS */

-- Get the year from a date when format is: YYYY-MM-DD --
SELECT
	START_DATE,
	LEFT(start_date, 4) AS START_YEAR
FROM STAFF

 -- Get the month from a date when the format is: YYYY-MM-DD --
SELECT
	START_DATE, 
	RIGHT(START_DATE, 2) AS START_MONTH
FROM STAFF


-- Get the length of the values in the email column
SELECT
	EMAIL,
	LENGTH(EMAIL) AS LEN_EMAIL FROM STAFF


 -- Get the month AND day from a date when the format is: YYYY-MM-DD --
SELECT
	START_DATE, 
	SUBSTRING(START_DATE, 6)
FROM STAFF


/* Concatenation */
-- Let's concatenate an employees last name with their gender using CONCAT 
SELECT
	LAST_NAME, 
	GENDER, 
	CONCAT(LAST_NAME, ' ', 'is a ', GENDER)
FROM STAFF

-- You can also perform the concatenation using 2 pipe operators ||
SELECT
	LAST_NAME, 
	GENDER, 
	LAST_NAME  || ' is a ' || GENDER
FROM STAFF


/* Changing Case */

-- Change the region to upper case -- 
SELECT UPPER(COMPANY_REGIONS) FROM COMPANY_REGIONS

-- Change the country to lower case --
SELECT LOWER(COUNTRY) FROM COMPANY_REGIONS



/* Replacing Values */
-- Let replace all emails that contain the word 'google' with 'schmoogle' (Maybe in 40 years they like this name more?)

SELECT
	EMAIL, 
	REPLACE(EMAIL, 'google', 'schmoogle')
FROM STAFF
WHERE EMAIL LIKE '%google%'


/* FILTERING */
-- Let's take a look at employess with 'Analyst' in their job title
SELECT * FROM STAFF
WHERE JOB_TITLE LIKE ('%Analyst%')

-- There are different tiers of Analyst; Ex: Computer Systems Analyst I
-- Let's look at all the Analyst who have a tier to their title
SELECT * FROM STAFF 
WHERE JOB_TITLE LIKE '%Analyst I%'







