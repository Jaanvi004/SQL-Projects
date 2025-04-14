CREATE TABLE surgical_data (
    Patient_ID INT PRIMARY KEY,
    Patient_Name VARCHAR(255) NOT NULL,
    Address VARCHAR(255),
    Disease_Found VARCHAR(255) NOT NULL,
    Cure VARCHAR(255) NOT NULL,
    Medication VARCHAR(255),
    Assigned_Surgeon VARCHAR(255) NOT NULL,
    Insurance VARCHAR(50),
    Cost_of_Surgery MONEY NOT NULL,
    Discharge_Date DATE NOT NULL,
    After_Treatment_Effect VARCHAR(255),
    Follow_ups VARCHAR(50)
);
select * from surgical_data;

--null values
SELECT * FROM surgical_data 
WHERE Patient_ID IS NULL OR
    Patient_Name IS NULL OR
    Address IS NULL OR
    Disease_Found IS NULL OR
    Cure IS NULL OR
    Assigned_Surgeon IS NULL OR
    Cost_of_Surgery IS NULL OR
    Discharge_Date IS NULL;

-- validation of patient id
SELECT Patient_ID, COUNT(*) 
FROM surgical_data 
GROUP BY Patient_ID
HAVING COUNT(*) > 1;

--date formats
SELECT * 
FROM surgical_data 
WHERE TO_CHAR(Discharge_Date, 'YYYY-MM-DD') !~ '^\d{4}-\d{2}-\d{2}$';

--duplicates 
SELECT Patient_Name, Address, COUNT(*)
FROM surgical_data
GROUP BY Patient_Name, Address
HAVING COUNT(*) > 1;

SELECT * 
FROM surgical_data 
WHERE (Patient_Name, Address) IN (
    SELECT Patient_Name, Address
    FROM surgical_data
    GROUP BY Patient_Name, Address
    HAVING COUNT(*) > 1
)
ORDER BY Patient_Name, Address;

--excat duplicates
SELECT *, COUNT(*) 
FROM surgical_data 
GROUP BY Patient_ID, Patient_Name, Address, Disease_Found, Cure, Medication, Assigned_Surgeon, Insurance, Cost_of_Surgery, Discharge_Date, After_Treatment_Effect, Follow_Ups
HAVING COUNT(*) > 1;


--address
SELECT * 
FROM surgical_data 
WHERE Address ~ '[^a-zA-Z0-9\s,.-]';

--update the follow up column
UPDATE surgical_data
SET Follow_Ups = 
    CASE 
        WHEN Follow_Ups ~* '(\d+)\s*month' THEN 
            (regexp_replace(Follow_Ups, '(\d+)\s*month.*', '\1', 'g')::int * 4) || ' weeks'
        ELSE Follow_Ups 
    END;

select * from surgical_data;

CREATE TABLE administrative_support_services (
    Employee_ID INT PRIMARY KEY,
    Department VARCHAR(255) NOT NULL,
    Role VARCHAR(255) NOT NULL,
    Salary DECIMAL(12,2) NOT NULL,  -- Removes $ and ensures 2 decimal places
    Experience_Years INT CHECK (Experience_Years >= 0),  -- Ensures no negative values
    Location VARCHAR(255) NOT NULL,
    Date_of_Joining DATE NOT NULL  -- Converts to YYYY-MM-DD format
);

--null values
SELECT * 
FROM administrative_support_services 
WHERE 
    Employee_ID IS NULL OR 
    Department IS NULL OR 
    Role IS NULL OR 
    Salary IS NULL OR 
    Experience_Years IS NULL OR 
    Location IS NULL OR 
    Date_of_Joining IS NULL;

--duplicate employee id
SELECT Employee_ID, COUNT(*) 
FROM administrative_support_services 
GROUP BY Employee_ID
HAVING COUNT(*) > 1;

--validate department and role
SELECT DISTINCT Department FROM administrative_support_services;
SELECT DISTINCT Role FROM administrative_support_services;

--case formatting
SELECT DISTINCT Location 
FROM administrative_support_services
WHERE Location ~ '[a-z]';  -- Checks for lowercase letters

--salary
SELECT * 
FROM administrative_support_services 
WHERE Salary < 0;  -- No negative salaries

--validate experience 
SELECT * 
FROM administrative_support_services 
WHERE EXTRACT(YEAR FROM AGE(Date_of_Joining)) != Experience_Years;

--1.	Create total employee report from each department
SELECT Department, COUNT(Employee_ID) AS Total_Employees
FROM administrative_support_services
GROUP BY Department
ORDER BY Total_Employees DESC;

--2.	Create report for total employee role wise
SELECT Role, COUNT(Employee_ID) AS Total_Employees
FROM administrative_support_services
GROUP BY Role
ORDER BY Total_Employees DESC;

--3.	Create reports on salary offered for each role year wise with total salary for every department 
SELECT 
    Role, 
    Department, 
    EXTRACT(YEAR FROM date_of_joining) AS Year, 
    SUM(Salary) AS Total_Salary
FROM administrative_support_services
GROUP BY Role, Department, EXTRACT(YEAR FROM date_of_joining)
ORDER BY Year DESC, Total_Salary DESC;

--4.	Create report to track employee location and belonging
SELECT 
    Department,
    Location,
    COUNT(Employee_ID) AS Employee_Count
FROM 
    administrative_support_services
GROUP BY 
    Department, Location
ORDER BY 
    Department, Employee_Count DESC;

--5.	Create report on total employee hired in each year from oldest to recent, department wise
SELECT 
    EXTRACT(YEAR FROM date_of_joining) AS Year,  
    Department, 
    COUNT(Employee_ID) AS Total_Employees_Hired
FROM 
    administrative_support_services
GROUP BY 
    Year, Department
ORDER BY 
   Year ASC, Department;

--employees hired yearly,department and role wise
SELECT 
    EXTRACT(YEAR FROM date_of_joining) AS Year,
    Department, 
    Role, 
    COUNT(Employee_ID) AS Total_Employees_Hired
FROM 
    administrative_support_services
GROUP BY 
    YEAR, Department, Role
ORDER BY 
   Year ASC, Department, Role;

--client requirments on Healthcare Insights & Surgery Reports
--1.	Create report on types of disease found / month/ year
SELECT 
    DATE_PART('year', discharge_date) AS year, 
    DATE_PART('month', discharge_date) AS month,
    disease_found,
    COUNT(patient_id) AS total_cases
FROM surgical_data
WHERE disease_found IS NOT NULL
GROUP BY year, month, disease_found
ORDER BY year DESC, month DESC, total_cases DESC;

--2.	Create report on type of cure and medication provided / month/ year
SELECT  
    EXTRACT(YEAR FROM discharge_date) AS Year,  
    EXTRACT(MONTH FROM discharge_date) AS Month,  
    cure,  
    medication,  
    COUNT(*) AS total_cases  
FROM surgical_data  
GROUP BY Year, Month, cure, medication  
ORDER BY Year, Month;

--3.	Create reports on types of cases handled by surgeon/ month in total 
SELECT  
    TO_CHAR(discharge_date, 'YYYY-MM') AS Month_Year,  
    assigned_surgeon,  
    COUNT(patient_id) AS total_cases  
FROM surgical_data  
GROUP BY Month_Year, assigned_surgeon  
ORDER BY Month_Year DESC, total_cases DESC;

--4.	Create report to track insurance used by patient
SELECT  
    insurance,  
    COUNT(patient_id) AS total_patients  
FROM surgical_data  
WHERE insurance IS NOT NULL  
GROUP BY insurance  
ORDER BY total_patients DESC;

--5.	Create report to find cost of surgery / month/ year 
SELECT  
    EXTRACT(YEAR FROM discharge_date) AS Year,  
    EXTRACT(MONTH FROM discharge_date) AS Month,  
    SUM(cost_of_surgery) AS total_surgery_cost  
FROM surgical_data  
WHERE cost_of_surgery IS NOT NULL  
GROUP BY Year, Month  
ORDER BY Year DESC, Month DESC;

--6.	Report on after treatment effect
SELECT  
    after_treatment_effect,  
    COUNT(patient_id) AS total_patients  
FROM surgical_data  
WHERE after_treatment_effect IS NOT NULL  
GROUP BY after_treatment_effect  
ORDER BY total_patients DESC;

--7.	Time duration between follow up calls to track gap between follow ups.
SELECT  
    patient_id,  
    follow_ups,  
    discharge_date,  
    LEAD(discharge_date) OVER (PARTITION BY patient_id ORDER BY discharge_date) AS next_follow_up,  
    LEAD(discharge_date) OVER (PARTITION BY patient_id ORDER BY discharge_date) - discharge_date AS follow_up_gap  
FROM surgical_data  
WHERE follow_ups IS NOT NULL  
ORDER BY patient_id, discharge_date;

SELECT  
    patient_id,  
    discharge_date,  
    follow_ups,  
    discharge_date + INTERVAL '1 month' * CAST(REGEXP_REPLACE(follow_ups, '[^0-9]', '', 'g') AS INTEGER) AS next_follow_up,  
    (discharge_date + INTERVAL '1 month' * CAST(REGEXP_REPLACE(follow_ups, '[^0-9]', '', 'g') AS INTEGER)) - discharge_date AS follow_up_gap  
FROM surgical_data  
WHERE follow_ups IS NOT NULL  
ORDER BY patient_id, discharge_date;













