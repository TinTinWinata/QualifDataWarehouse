

-- Fact Sales get Data
USE OLAP_HospitallE


IF EXISTS(
	SELECT * 
	FROM FilterTimeStamp
	WHERE TableName = 'SalesFact'
)

BEGIN
SELECT 
	MedicineCode,
	StaffCode,
	CustomerCode,
	TimeCode,
    [Total Sales Earning] = SUM(Quantity * mm.MedicineSellingPrice),
    [Total Medicine Sold] = SUM(Quantity)
FROM
	OLTP_HospitalIE.dbo.MsMedicine  mm
	JOIN OLTP_HospitalIE.dbo.TrSalesDetail sd ON sd.MedicineID = mm.MedicineID
	JOIN OLTP_HospitalIE.dbo.TrSalesHeader sh ON sh.SalesID = sd.SalesID
	JOIN MedicineDimension medim ON medim.MedicineID = sd.MedicineID
	JOIN CustomerDimension cusdim ON cusdim.CustomerID =sh.CustomerID
	JOIN StaffDimension stadim ON stadim.StaffID = sh.StaffID
	JOIN TimeDimension tdim on tdim.Date = sh.SalesDate
WHERE 
	sh.SalesDate > (
		SELECT LastETL FROM FilterTimeStamp
		WHERE TableName = 'SalesFact'
	)
GROUP BY MedicineCode, StaffCode, CustomerCode, TimeCode

END

ELSE
BEGIN 
SELECT 
	MedicineCode,
	StaffCode,
	CustomerCode,
	TimeCode,
    [Total Sales Earning] = SUM(Quantity * mm.MedicineSellingPrice),
    [Total Medicine Sold] = SUM(Quantity)
FROM
	OLTP_HospitalIE.dbo.MsMedicine  mm
	JOIN OLTP_HospitalIE.dbo.TrSalesDetail sd ON sd.MedicineID = mm.MedicineID
	JOIN OLTP_HospitalIE.dbo.TrSalesHeader sh ON sh.SalesID = sd.SalesID
	JOIN MedicineDimension medim ON medim.MedicineID = sd.MedicineID
	JOIN CustomerDimension cusdim ON cusdim.CustomerID =sh.CustomerID
	JOIN StaffDimension stadim ON stadim.StaffID = sh.StaffID
	JOIN TimeDimension tdim on tdim.Date = sh.SalesDate
GROUP BY MedicineCode, StaffCode, CustomerCode, TimeCode

END


-- Query Execution

 IF EXISTS(
	SELECT * 
	FROM FilterTimeStamp WHERE TableName = 'SalesFact'
 )
 BEGIN 
	UPDATE FilterTimeStamp
	SET LastETL = GETDATE()
	WHERE TableName ='SalesFact'
 END
 ELSE
 BEGIN
	INSERT INTO FilterTimeStamp VALUES ('SalesFact', GETDATE())
 END

 

