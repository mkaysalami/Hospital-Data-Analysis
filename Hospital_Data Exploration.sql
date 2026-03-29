## Question1: For each doctor, count how many distinct patients they have treated.

SELECT doc.DoctorID,
       CONCAT(doc.FirstName, ' ', doc.LastName) AS DoctorName,
       COUNT(DISTINCT v.PatientID) AS DistinctPatients
FROM PatientVisits v
JOIN Dim_Doctor doc
ON v.DoctorID = doc.DoctorID
GROUP BY doc.DoctorID, doc.FirstName, doc.LastName
ORDER BY DistinctPatients DESC;


## Question 2: Show the revenue split by each payment method, along with total visits.

SELECT pm.PaymentMethod,
       COUNT(v.VisitID) AS TotalVisits,
       SUM(v.BillAmount) AS TotalRevenue
FROM PatientVisits v
JOIN Dim_PaymentMethod pm
ON v.PaymentMethodID = pm.PaymentMethodID
GROUP BY pm.PaymentMethod


## Question 3: Categorize patients into age groups and calculate the average bill amount for each age band.(Assume age at time of 

WITH cte_PatientAge AS (
    SELECT 
        v.VisitID, 
        v.BillAmount,
        CASE
            WHEN TIMESTAMPDIFF(YEAR, p.DOB, v.VisitDate) < 18 THEN '0-17'
            WHEN TIMESTAMPDIFF(YEAR, p.DOB, v.VisitDate) BETWEEN 18 AND 35 THEN '18-35'
            WHEN TIMESTAMPDIFF(YEAR, p.DOB, v.VisitDate) BETWEEN 36 AND 55 THEN '36-55'
            ELSE '56+'
        END AS AgeGroup
    FROM DIM_Patient_Clean p
    JOIN PatientVisits v 
        ON v.PatientID = p.PatientID
)

SELECT 
    AgeGroup,
    COUNT(*) AS TotalVisits,
    CAST(AVG(BillAmount) AS DECIMAL(18,2)) AS AvgBillAmount
FROM cte_PatientAge
GROUP BY AgeGroup
ORDER BY 
    CASE AgeGroup
        WHEN '0-17' THEN 1
        WHEN '18-35' THEN 2
        WHEN '36-55' THEN 3
        WHEN '56+' THEN 4
    END;
 
 
 ## Question 4: Find total revenue and number of visits for each department.
 
 SELECT d.DepartmentName,
        COUNT(v.VisitID) AS TotalVisits,
        SUM(v.BillAmount) AS TotalRevenue
FROM PatientVisits v
JOIN DIM_Department_Clean d
ON v.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName
ORDER BY TotalRevenue DESC
 
 
 ## Question 5: Rank Departments based on their total revenue within each department category
 
 SELECT DepartmentCategory, DepartmentName, TotalRevenue,
        RANK() OVER (PARTITION BY DepartmentCategory ORDER BY TotalRevenue DESC) AS RevenueRank
FROM  (
      SELECT d.DepartmentCategory, d.DepartmentName,
          SUM(v.BillAmount) AS TotalRevenue
      FROM PatientVisits v
      JOIN DIM_Department_Clean d
	ON v.DepartmentID = d.DepartmentID
	  GROUP BY d.DepartmentCategory, d.DepartmentName
      ) t
      

## Question 6: For each department, find the average satisfaction score and average wait time.

SELECT d.DepartmentName,
	   CAST(AVG(v.SatisfactionScore) AS DECIMAL (10,2)) AS AvgSatisfactionScore,
       CAST(AVG(v.WaitTimeMinutes) AS DECIMAL (10,2)) AS  AvgWaitTime
FROM PatientVisits v
JOIN DIM_Department_Clean d
ON v.DepartmentID = d.departmentID
GROUP BY d.DepartmentName
ORDER BY AvgSatisfactionScore DESC

 
 ## Question 7: Compare the total number of hospital visits on weekdays and weekends
 
 SELECT 
    DayType, 
    COUNT(*) AS TotalVisits
FROM (
    SELECT
        CASE
            WHEN DAYNAME(VisitDate) IN ('Saturday', 'Sunday') THEN 'Weekend'
            ELSE 'Weekday'
        END AS DayType
    FROM PatientVisits
) t
GROUP BY DayType;


## Question 8: For each month, calculate total visits and a running cummulative total of visits.

WITH cte_monthlyVisits AS (
    SELECT 
        DATE_FORMAT(VisitDate, '%Y-%m-01') AS MonthStart,
        COUNT(*) AS TotalVisits
    FROM PatientVisits
    GROUP BY MonthStart
)
SELECT 
    MonthStart,
    TotalVisits,
    SUM(TotalVisits) OVER (
        ORDER BY MonthStart
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS CumulativeVisits
FROM cte_monthlyVisits
ORDER BY MonthStart;


## Quesion 9: Find the doctors with the highest average satisfaction score(minimum 100 visits)

SELECT 
    d.DoctorID,
    CONCAT(d.FirstName, ' ', d.LastName) AS DoctorName,
    COUNT(v.VisitID) AS TotalVisits,
    CAST(AVG(v.SatisfactionScore) AS DECIMAL (10,2)) AS  AvgSatisfactionScore
FROM Dim_Doctor d
JOIN PatientVisits v
    ON d.DoctorID = v.DoctorID
GROUP BY d.DoctorID, d.FirstName, d.LastName
HAVING COUNT(v.VisitID) > 100


## Question 10: Identify the most commonly prescribed treatment for each diagnosis

WITH cte_TreatmentCounts AS (
    SELECT 
        d.DiagnosisName,
        t.TreatmentName,
        COUNT(*) AS TreatmentCount
    FROM PatientVisits v
    JOIN Dim_Diagnosis d ON v.DiagnosisID = d.DiagnosisID
    JOIN Dim_Treatment t ON t.TreatmentID = v.TreatmentID
    GROUP BY d.DiagnosisName, t.TreatmentName
)
SELECT 
    DiagnosisName,
    TreatmentName,
    TreatmentCount,
    RANK() OVER (
        PARTITION BY DiagnosisName
        ORDER BY TreatmentCount DESC
    ) AS rn
FROM cte_TreatmentCounts
ORDER BY DiagnosisName, rn;
 
 
 
 
 
 
 
 
 