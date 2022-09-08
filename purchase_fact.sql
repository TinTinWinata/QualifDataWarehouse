

-- Fact Purchase Get Data
USE OLAP_HospitallE

IF EXISTS(
	SELECT * 
	FROM FilterTimeStamp
	WHERE TableName = 'PurchaseFact'
)

BEGIN
SELECT 
	MedicineCode,
	StaffCode,
	DistributorCode,
	TimeCode,
	[Total Purchase Cost] = SUM(Quantity * mm.MedicineBuyingPrice),
    [Total Medicine Purchased] = SUM(Quantity)
FROM
	OLTP_HospitalIE.dbo.MsMedicine  mm
	JOIN OLTP_HospitalIE.dbo.TrSalesDetail sd ON sd.MedicineID = mm.MedicineID
	JOIN OLTP_HospitalIE.dbo.TrSalesHeader sh ON sh.SalesID = sd.SalesID
	JOIN OLTP_HospitalIE.dbo.TrPurchaseHeader ph ON ph.StaffID = sh.StaffID
	JOIN DistributorDimension disdim ON disdim.DistributorID = ph.DistributorID
	JOIN MedicineDimension medim ON medim.MedicineID = sd.MedicineID
	JOIN StaffDimension stadim ON stadim.StaffID = sh.StaffID
	JOIN TimeDimension tdim on tdim.Date = ph.PurchaseDate
WHERE 
	ph.PurchaseDate > (
		SELECT LastETL FROM FilterTimeStamp
		WHERE TableName = 'PurchaseFact'
	)
GROUP BY MedicineCode, StaffCode, TimeCode, DistributorCode

END

ELSE
BEGIN 
SELECT 
	MedicineCode,
	StaffCode,
	DistributorCode,
	TimeCode,
	[Total Purchase Cost] = SUM(Quantity * mm.MedicineBuyingPrice),
    [Total Medicine Purchased] = SUM(Quantity)
FROM
	OLTP_HospitalIE.dbo.MsMedicine  mm
	JOIN OLTP_HospitalIE.dbo.TrSalesDetail sd ON sd.MedicineID = mm.MedicineID
	JOIN OLTP_HospitalIE.dbo.TrSalesHeader sh ON sh.SalesID = sd.SalesID
	JOIN OLTP_HospitalIE.dbo.TrPurchaseHeader ph ON ph.StaffID = sh.StaffID
	JOIN DistributorDimension disdim ON disdim.DistributorID = ph.DistributorID
	JOIN MedicineDimension medim ON medim.MedicineID = sd.MedicineID
	JOIN StaffDimension stadim ON stadim.StaffID = sh.StaffID
	JOIN TimeDimension tdim on tdim.Date = sh.SalesDate
GROUP BY MedicineCode, StaffCode, TimeCode, DistributorCode

END

-- Query Execution

 IF EXISTS(
	SELECT * 
	FROM FilterTimeStamp WHERE TableName = 'PurchaseFact'
 )
 BEGIN 
	UPDATE FilterTimeStamp
	SET LastETL = GETDATE()
	WHERE TableName ='PurchaseFact'
 END
 ELSE
 BEGIN
	INSERT INTO FilterTimeStamp VALUES ('PurchaseFact', GETDATE())
 END


 