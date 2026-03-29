CREATE TABLE DIM_Patient_Clean(
      PatientID varchar(20) PRIMARY KEY,
      FullName varchar(120),
      Gender varchar(10),
      DOB date,
      City varchar(50),
      State varchar(50),
      Country varchar(50)
)

INSERT INTO DIM_Patient_Clean (
		PatientID, FullName, Gender, DOB, City, State, Country
)
SELECT
    p.PatientID,
    CONCAT(
        UPPER(LEFT(TRIM(p.FirstName), 1)),
        LOWER(SUBSTRING(TRIM(p.FirstName), 2)),
        ' ',
        UPPER(LEFT(TRIM(p.LastName), 1)),
        LOWER(SUBSTRING(TRIM(p.LastName), 2))
    ) AS FullName,

    CASE
        WHEN p.Gender = 'M' THEN 'Male'
        WHEN p.Gender = 'F' THEN 'Female'
        ELSE p.Gender
    END AS Gender,

    p.DOB,

    TRIM(SUBSTRING_INDEX(p.CityStateCountry, ',', 1)) AS City,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(p.CityStateCountry, ',', 2), ',', -1)) AS State,
    TRIM(SUBSTRING_INDEX(p.CityStateCountry, ',', -1)) AS Country

FROM Dim_Patient p
WHERE p.FirstName IS NOT NULL;