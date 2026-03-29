CREATE TABLE DIM_Department_Clean(
      DepartmentID Varchar(20) Primary Key,
      DepartmentName Varchar(100),
      DepartmentCategory Varchar(100)
);

INSERT INTO DIM_Department_Clean(
     DepartmentID, DepartmentName, DepartmentCategory
)

SELECT d.DepartmentID, d.Specialization AS DepartmentName, d.DepartmentCategory
FROM DIM_Department d
WHERE d.DepartmentCategory IS NOT NULL;