CREATE TABLE PatientVisits (
     VisitID VARCHAR(20)   PRIMARY KEY,
     PatientID  VARCHAR(20),
     DoctorID   VARCHAR(20),
     DepartmentID  VARCHAR(20),
	 DiagnosisID   VARCHAR(20),
     TreatmentID   VARCHAR(20),
     PaymentMethodID  VARCHAR(20),
     VisitDate       DATE,
     VisitTime       TIME,
     DischargeDate  DATE,
     BillAmount      DECIMAL(18,2),
     InsuranceAmount  DECIMAL(18,2),
     SatisfactionScore  INT,
     WaitTimeMinutes   INT,
     
	 FOREIGN KEY(PatientID)        REFERENCES  DIM_Patient_Clean(PatientID),
     FOREIGN KEY(DoctorID)         REFERENCES  Dim_Doctor(DoctorID),
     FOREIGN KEY(DepartmentID)     REFERENCES  DIM_Department_Clean(DepartmentID),
     FOREIGN KEY(DiagnosisID)      REFERENCES  Dim_Diagnosis(DiagnosisID),
     FOREIGN KEY(TreatmentID)      REFERENCES  Dim_Treatment(TreatmentID),
     FOREIGN KEY(PaymentMethodID)  REFERENCES  Dim_PaymentMethod(PaymentMethodID)
);

INSERT INTO PatientVisits (
      VisitID, PatientID, DoctorID, DepartmentID, DiagnosisID, TreatmentID, 
      PaymentMethodID, VisitDate, VisitTime, DischargeDate, 
      BillAmount, InsuranceAmount, SatisfactionScore, WaitTimeMinutes
)

SELECT
      VisitID, PatientID, DoctorID, DepartmentID, DiagnosisID, TreatmentID, 
      PaymentMethodID, VisitDate, VisitTime, DischargeDate, 
      BillAmount, InsuranceAmount, SatisfactionScore, WaitTimeMinutes
FROM PatientVisits_2020_2021

UNION ALL

SELECT
      VisitID, PatientID, DoctorID, DepartmentID, DiagnosisID, TreatmentID, 
      PaymentMethodID, VisitDate, VisitTime, DischargeDate, 
      BillAmount, InsuranceAmount, SatisfactionScore, WaitTimeMinutes
FROM PatientVisits_2022_2023

UNION ALL

SELECT
      VisitID, PatientID, DoctorID, DepartmentID, DiagnosisID, TreatmentID, 
      PaymentMethodID, VisitDate, VisitTime, DischargeDate, 
      BillAmount, InsuranceAmount, SatisfactionScore, WaitTimeMinutes
FROM PatientVisits_2024

UNION ALL

SELECT
      VisitID, PatientID, DoctorID, DepartmentID, DiagnosisID, TreatmentID, 
      PaymentMethodID, VisitDate, VisitTime, DischargeDate, 
      BillAmount, InsuranceAmount, SatisfactionScore, WaitTimeMinutes
FROM PatientVisits_2025;

     