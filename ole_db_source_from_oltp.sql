-- Find MedicineDimension OLTP 
SELECT 
	MedicineID ,
	MedicineName,
	MedicineSellingPrice,
	MedicineBuyingPrice,
	MedicineExpiredDate
FROM OLTP_HospitalIE.dbo.MsMedicine

-- Find DoctorDimension OLTP
SELECT
 DoctorID,
 DoctorName,
 DoctorDOB,
 DoctorAddress,
 DoctorSalary
FROM OLTP_HospitalIE.dbo.MsDoctor

-- Find StaffDimension OLTP
SELECT 
StaffID,
StaffName,
StaffDOB,
StaffSalary,
StaffAddress
FROM OLTP_HospitalIE.dbo.MsStaff

-- Find CustomerDimension OLTP
SELECT
 CustomerID,
 CustomerName,
 CustomerAddress,
 CustomerGender
FROM OLTP_HospitalIE.dbo.MsCustomer

-- Find BenefitDimesion OLTP
SELECT 
BenefitID,
BenefitName,
BenefitPrice 
FROM OLTP_HospitalIE.dbo.MsBenefit


-- Find TreatmentDimension OLTP
SELECT
TreatmentID,
TreatmentName,
TreatmentPrice
FROM OLTP_HospitalIE.dbo.MsTreatment


-- Find DistributorDimension
SELECT
DistributorID,
DistributorName,
DistributorAddress,
DistributorPhone
FROM OLTP_HospitalIE.dbo.MsDistributor

-- Testing
SELECT * FROM MedicineDimension
SELECT * FROM DoctorDimension
SELECT * FROM StaffDimension
SELECT * FROM CustomerDimension
SELECT * FROM BenefitDimension
SELECT * FROM TreatmentDimension
SELECT * FROM DistributorDimension



