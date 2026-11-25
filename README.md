# US-Household-Income-Project-DC
📂 **[SQL Query](https://github.com/davmaane/US-Household-Income-Project-DC/blob/main/US%20Household%20Income%20Project%20DC.sql)**

## Table of Contents
* [Project Overview](#project-overview)
* [Dataset Information](#dataset-information)
* [Tools Used](#tools-used)
* [Data Quality Assessment](#data-quality-assessment)
* [Data Cleaning Process](#data-cleaning-process)
* [Standardizing Data](#standardizing-data)
* [Handling Missing Values](#handling-missing-values)
* [Cleaned Dataset Summary](#cleaned-dataset-summary)

## Project Overview
Income is a vital element when determining both quality and socio economic features of a given geographic location. This project focuses on cleaning and preparing for analysis a US Household Income Statistics Dataset.

## Dataset Information
This dataset contains 32,000+ records on US Household Income Statistics and Geo Locations. The dataset covers 348,893 location records.
 
- Source: Golden Oak Research Group, Kaggle
 
- Number of rows: 32,292
 
- Number of columns: 16
 
## Tools Used
- SQL (MySQL)

## Data Quality Assessment
Here are the issues identified during the initial process:
- Duplicate records
- Blank values
- Inconsistent text
  

## Data Cleaning Process

Here is a quick overview of the dataset 

<img width="1377" height="282" alt="Screenshot 2026-11-21 080146" src="https://github.com/user-attachments/assets/b3c6a89e-9499-481b-b678-26c268354b7b" />


### Removing Duplicates
To identify duplicate records, I ran a count on the ID column, which should contain unique values for each respondent
```sql
SELECT id, COUNT(id)
FROM us_household_income_project.ushouseholdincome
GROUP BY id
HAVING COUNT(id) > 1;
--- identified 6 duplicate records 

```
<img width="167" height="160" alt="Screenshot 2026-11-21 081104" src="https://github.com/user-attachments/assets/b532bd1c-8ec8-4ba7-b7ae-ccb5c9ea60ef" />

After identifying the duplicate records, I removed them using this subquery:
```sql
DELETE FROM ushouseholdincome
WHERE 
     row_id IN (
     SELECT row_id
FROM (
     SELECT row_id,
     	id,
     	ROW_NUMBER() OVER (PARTITION BY id ORDER BY id) row_num
     FROM us_household_income_project.ushouseholdincome
     ) duplicates
WHERE row_num > 1);
---successfully removed all the duplicates in our data
```

 ## Standardizing Data
I standardized the 'State_name' and 'Type' columns using a similar update query, changing only the column name. The before and after results are shown below.

- query used:

```sql
UPDATE  us_household_income_project.ushouseholdincome
Set State_name = 'Georgia' 
where State_name = 'Georia'
;
```
before: <img width="147" height="137" alt="image" src="https://github.com/user-attachments/assets/e1fac197-aa5f-4cb7-b084-518f0e438c26" />
        after: <img width="151" height="138" alt="image" src="https://github.com/user-attachments/assets/a4a16883-32ee-4d20-b174-5d5caa81d796" />

before: <img width="203" height="131" alt="image" src="https://github.com/user-attachments/assets/fb76e792-b3b5-4898-870a-299fcac42d00" />         after: <img width="197" height="133" alt="image" src="https://github.com/user-attachments/assets/340b1c92-91dc-4883-8286-eaebd1d89c7a" />




##  Handling Missing Values
Handled missing values in the place column by populating them with "Autaugaville" for records where the county was "Autauga County", as Autaugaville accounted for 98% of the existing place values within that county.

- Query used
```sql
UPDATE ushouseholdincome
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
AND City = 'Vinemont';
```
before:  <img width="222" height="133" alt="image" src="https://github.com/user-attachments/assets/693b9d86-003e-4c6a-947f-1628220837cb" />  after: <img width="216" height="127" alt="image" src="https://github.com/user-attachments/assets/4a87a82e-0e1b-4c79-ac18-0571d3f806d3" />


## Cleaned Dataset Summary
Key steps completed during the data cleaning process:
- Removed 6 duplicate records
- Text & Spelling Standardization on the 'State_name' and 'type' columns
- Handled missing values in the 'place' column
- Checked every other column to make sure the dataset is ready for analysis

The cleaned dataset was used for Exploratory Data Analysis (EDA) to uncover trends and insights.

🔗 [View the EDA project](https://github.com/davmaane/US-Household-Income-Project-EDA/tree/main)
