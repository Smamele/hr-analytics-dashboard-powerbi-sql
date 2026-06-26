--Question 1 — Total Employees by Department--
SELECT Department,
       COUNT(*) AS Total_Employees
FROM HRdata
GROUP BY Department
Order BY Total_Employees DESC;

--Question 2 — Average Salary by Department--
SELECT Department,
       AVG(MonthlySalary) AS Average_Salary
FROM HRdata
GROUP BY Department
Order BY Average_Salary DESC;

--Question 3 — Which Department Has the Highest Attrition?--
SELECT Department,
       COUNT(*) AS Employees_Left
FROM HRData
WHERE Attrition = 1
GROUP BY Department
ORDER BY Employees_Left DESC;

--Question 4 — Top 5 Job Roles by Average Salary--
SELECT TOP 5 JobRole,
       AVG(MonthlySalary) AS Average_Salary
FROM HRdata
GROUP BY JobRole
Order BY Average_Salary DESC;

--Question 5 — Which Province Has the Highest Employee Turnover?--
SELECT Province,
       COUNT(*) AS Employees_Left
FROM HRdata
WHERE Attrition = 1
GROUP BY Province
Order BY Employees_Left DESC;

--Question 6 — Does Overtime Increase Attrition?--
SELECT 
    Overtime,
    COUNT(*) AS Employees_Count,
    SUM(CAST(Attrition AS INT)) AS Employees_Left
FROM HRdata
GROUP BY Overtime
ORDER BY Employees_Left DESC;

--Question 7 — Employees Earning Above Average Salary--
SELECT EmployeeID,
       Department,
       MonthlySalary
FROM HRData
WHERE MonthlySalary >
(
    SELECT AVG(MonthlySalary)
    FROM HRData
);

--Question 8: Rank Departments by Salary--
WITH DepartmentRankData AS
(
SELECT Department,
       AVG(MonthlySalary) AS Average_Salary
FROM HRData
GROUP BY Department
)
SELECT Department,
       Average_Salary,
       RANK() OVER(ORDER BY Average_Salary DESC) AS Salary_Rank,
       ROW_NUMBER() OVER(ORDER BY Average_Salary DESC) AS Row_Num
FROM DepartmentRankData;

--Question 9 — Top Department in Each Province by Employee Count--
WITH DepartmentProvinceData AS
(
SELECT Department,
       Province,
       COUNT(*) AS Total_Employee
FROM HRData
GROUP BY Department,Province
),
RankedData AS
(
SELECT Department,
       Province,
       Total_Employee,
       RANK() OVER(PARTITION BY Province ORDER BY  Total_Employee DESC) AS Department_Rank
FROM DepartmentProvinceData
)
SELECT Department,
       Province,
       Total_Employee,
       Department_Rank
FROM RankedData 
WHERE Department_Rank = 1;

--Question 10 — Excellent Performers Without Promotion--
SELECT EmployeeID,
       Department,
       JobRole,
       PerformanceRating
FROM HRData
WHERE PerformanceRating = 'Excellent'
AND PromotionLast3Years = 0;

--Question 11 — Average Job Satisfaction by Department--
SELECT Department,
       AVG(
           CASE
               WHEN JobSatisfaction = 'Low' THEN 1
               WHEN JobSatisfaction = 'Medium' THEN 2
               WHEN JobSatisfaction = 'High' THEN 3
           END
       ) AS Average_Job_Satisfaction
FROM HRData
GROUP BY Department
ORDER BY Average_Job_Satisfaction DESC;

--Question 12 — Average Training Hours by Department--
SELECT 
    Department,
    AVG(TrainingHours) AS Average_Training_Hours
FROM HRData
GROUP BY Department
ORDER BY Average_Training_Hours DESC;

--Question 13 — Attrition Rate by Gender--
SELECT Gender,
       COUNT(CASE WHEN Attrition = 1 THEN 1 END) * 100.0 / COUNT(*) AS Attrition_Rate
FROM HRData
GROUP BY Gender;

--Question 14 — Attrition Rate by Employment Type--
SELECT
EmploymentType,
COUNT(CASE WHEN Attrition=1 THEN 1 END)*100.0/COUNT(*) AS Attrition_Rate
FROM HRData
GROUP BY EmploymentType;

--Question 15 — Employees With More Than 10 Years at the Company--
SELECT EmployeeID,
       Department,
       JobRole,
       YearsAtCompany
FROM HRData
WHERE YearsAtCompany > 10
ORDER BY YearsAtCompany DESC;

--Question 16 — Top 5 Departments With the Highest Average Salary--
SELECT TOP 5 Department,
       AVG(MonthlySalary) AS Average_Salary
FROM HRData
GROUP BY Department
ORDER BY Average_Salary DESC;

--Question 17 — Relationship Between Job Satisfaction and Attrition--
SELECT JobSatisfaction,
       COUNT(*) AS Employees_Left
FROM HRData
WHERE Attrition = 1
GROUP BY JobSatisfaction
ORDER BY Employees_Left DESC;

--Question 18 — Average Sick Leave Days by Department--
SELECT Department,
       AVG(SickLeaveDays) AS Average_Sick_Leave
FROM HRData
GROUP BY Department
ORDER BY Average_Sick_Leave DESC;

--Question 19 — Employees Eligible for Promotion (High Performance + Long Tenure)--
SELECT EmployeeID,
       Department,
       JobRole,
       YearsAtCompany,
       PerformanceRating
FROM HRData
WHERE PerformanceRating = 'Excellent'
AND YearsAtCompany >= 5
AND PromotionLast3Years = 0;

--Question 20 — Department Performance Ranking--
WITH DepartmentPerformanceData AS
(
    SELECT Department,
           COUNT(*) AS Excellent_Performers
    FROM HRData
    WHERE PerformanceRating = 'Excellent'
    GROUP BY Department
)
SELECT Department,
       Excellent_Performers,
       RANK() OVER(ORDER BY Excellent_Performers DESC) AS Performance_Rank
FROM DepartmentPerformanceData;
