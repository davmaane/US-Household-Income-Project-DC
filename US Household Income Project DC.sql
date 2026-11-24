# US Household 	Income Project

## Data Cleaning


SELECT * 
FROM us_household_income_project.ushouseholdincome;


SELECT * 
FROM us_household_income_project.ushouseholdincome_statistics;

# Fixing Column name on the statistics table

ALTER TABLE us_household_income_project.ushouseholdincome_statistics
RENAME COLUMN `ï»¿id` TO `id`;


SELECT COUNT(id)
FROM us_household_income_project.ushouseholdincome;


SELECT COUNT(id) 
FROM us_household_income_project.ushouseholdincome_statistics;

# Checking for duplicates and removing them

SELECT id, COUNT(id)
FROM us_household_income_project.ushouseholdincome
GROUP BY id
HAVING COUNT(id) >  1;
# identified 6 duplicates

SELECT *
FROM (
	SELECT row_id,
	id,
    ROW_NUMBER() OVER (PARTITION BY id ORDER BY id) row_num
    FROM us_household_income_project.ushouseholdincome
    ) duplicates
WHERE row_num > 1;
# this subquery targets all duplicates ready to be removed

DELETE FROM ushouseholdincome
WHERE row_id IN
(
	SELECT row_id
    FROM (
		SELECT row_id,
        id,
        ROW_NUMBER() OVER (PARTITION BY id ORDER BY id) row_num
        FROM us_household_income_project.ushouseholdincome
        ) duplicates
	WHERE row_num > 1);
    # successdully removed all duplicates

SELECT COUNT(id)
FROM us_household_income_project.ushouseholdincome_statistics
GROUP BY id
HAVING COUNT(id) >  1
; 

# Standardizing the State_name column

SELECT DISTINCT state_name
FROM us_household_income_project.ushouseholdincome
GROUP BY State_Name
;

UPDATE  us_household_income_project.ushouseholdincome
Set State_name = 'Georgia' 
where State_name = 'Georia'
;

UPDATE  us_household_income_project.ushouseholdincome
Set State_name = 'Alabama' 
where State_name = 'alabama'
;


# Standardizing the Type column

SELECT Type, COUNT(Type)
FROM us_household_income_project.ushouseholdincome
GROUP BY Type;  

UPDATE ushouseholdincome
SET Type = 'Borough'
WHERE Type =  'Boroughs'
;

# Fixing blank values

SELECT * 
FROM us_household_income_project.ushouseholdincome;

SELECT *
FROM us_household_income_project.ushouseholdincome
WHERE Place  = ''
;

SELECT *
FROM us_household_income_project.ushouseholdincome
WHERE County  = 'Autauga County'
;

UPDATE ushouseholdincome
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
AND City = 'Vinemont'
;


# checking other columns


SELECT distinct AWater
FROM us_household_income_project.ushouseholdincome
WHERE AWater = 0 OR AWater is NULL  
;

SELECT ALand, AWater
FROM us_household_income_project.ushouseholdincome
WHERE ALand = 0 OR ALand IS NULL
;
