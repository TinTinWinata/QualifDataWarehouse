CREATE DATABASE OLAP_HospitallE

GO
USE OLAP_HospitallE
GO

-- Create Dimension

CREATE TABLE MedicineDimension(
	MedicineCode INT PRIMARY KEY IDENTITY,
	MedicineID INT,
	MedicineName VARCHAR(100),
	MedicineSellingPrice BIGINT,
	MedicineBuyingPrice BIGINT,
	MedicineExpiredDate DATE,
)


CREATE TABLE DoctorDimension(
 DoctorCode INT PRIMARY KEY IDENTITY,
 DoctorID INT,
 DoctorName VARCHAR(100),
 DoctorDOB DATE,
 DoctorAddress VARCHAR(100),
 DoctorSalary BIGINT,
 ValidFrom DATE,
 ValidTo DATE
)


CREATE TABLE StaffDimension(
 StaffCode INT PRIMARY KEY IDENTITY,
 StaffID INT,
 StaffName VARCHAR(100),
 StaffDOB DATE,
 StaffSalary BIGINT,
 StaffAddress VARCHAR(100),
 ValidFrom DATE,
 ValidTo DATE
 )


 CREATE TABLE CustomerDimension (
 CustomerCode INT PRIMARY KEY IDENTITY,
 CustomerID INT,
 CustomerName VARCHAR(100),
 CustomerAddress VARCHAR(100),
 CustomerGender VARCHAR(6)
 )


 CREATE TABLE BenefitDimension(
 BenefitCode INT PRIMARY KEY IDENTITY,
 BenefitID INT,
 BenefitName VARCHAR(100),
 BenefitPrice BIGINT,
 ValidFrom DATE,
 ValidTo DATE
 )

 CREATE TABLE TreatmentDimension (
 TreatmentCode INT PRIMARY KEY IDENTITY,
 TreatmentID INT,
 TreatmentName VARCHAR(100),
 TreatmentPrice BIGINT,
 ValidFrom DATE,
 ValidTo DATE
 )

 CREATE TABLE DistributorDimension(
 DistributorCode INT PRIMARY KEY IDENTITY,
 DistributorID INT,
 DistributorName VARCHAR(100),
 DistributorAddress VARCHAR(100),
 DistributorPhone VARCHAR(15)
 )


 CREATE TABLE TimeDimension(
		TimeCode INT PRIMARY KEY IDENTITY,
		[Month] INT, 
		[Quarter] INT,
		[Year] INT,
		[Day] INT,
		[Date] DATE,
)

CREATE TABLE FilterTimeStamp(
	TableName VARCHAR(255) PRIMARY KEY,
	LastETL DATETIME,
)


-- Create Fact

CREATE TABLE SalesFact(
 MedicineCode INT, 
 StaffCode INT, 
 CustomerCode INT,
 TimeCode INT,
 [Total Sales Earning] BIGINT,
 [Total Medicine Sold] BIGINT
)

CREATE TABLE PurchaseFact(
 MedicineCode INT,
 StaffCode INT,
 DistributorCode INT,
 TimeCode INT,
 [Total Purchase Cost] BIGINT,
 [Total Medicine Purchased] BIGINT,
)

CREATE TABLE SubscriptionFact(
 StaffCode INT,
 CustomerCode INT,
 BenefitCode INT,
 TimeCode INT,
 [Total Subscription Earning] BIGINT,
 [Number Of Subscriber] BIGINT,
)

CREATE TABLE ServiceFact(
 CustomerCode INT,
 TreatmentCode INT,
 DoctorCode INT,
 TimeCode INT,
 [Total Service Earning] BIGINT,
 [Number Of Doctor] BIGINT,
)

