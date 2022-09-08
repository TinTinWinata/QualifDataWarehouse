

-- Fact Service Get Data

USE OLAP_HospitallE
IF EXISTS(
	SELECT * 
	FROM FilterTimeStamp
	WHERE TableName = 'ServiceFact'
)

BEGIN
SELECT 
	CustomerCode,
	TreatmentCode,
	DoctorCode,
	TimeCode,
    [Total Service Earning] = SUM(Quantity * TreatmentPrice),
    [Number Of Doctor] = COUNT(md.DoctorID)
FROM
	OLTP_HospitalIE.dbo.TrServiceHeader tsh 
	JOIN OLTP_HospitalIE.dbo.MsCustomer mc ON mc.CustomerID = tsh.CustomerID
	JOIN OLTP_HospitalIE.dbo.TrServiceDetail  tsd ON tsd.ServiceID = tsh.ServiceID
	JOIN OLTP_HospitalIE.dbo.MsDoctor md ON md.DoctorID = tsh.DoctorID
	JOIN DoctorDimension docdim ON docdim.DoctorID = tsh.DoctorID
	JOIN TreatmentDimension treatdim ON treatdim.TreatmentID = tsd.TreatmentID
	JOIN CustomerDimension cusdim ON cusdim.CustomerID = mc.CustomerID
	JOIN TimeDimension timedim ON timedim.Date = tsh.ServiceDate

WHERE 
	tsh.ServiceDate > (
		SELECT LastETL FROM FilterTimeStamp
		WHERE TableName = 'ServiceFact'
	)
GROUP BY CustomerCode, TreatmentCode, DoctorCode, TimeCode

END

ELSE
BEGIN 
SELECT 
	CustomerCode,
	TreatmentCode,
	DoctorCode,
	TimeCode,
    [Total Service Earning] = SUM(Quantity * TreatmentPrice),
    [Number Of Doctor] = COUNT(md.DoctorID)
FROM
	OLTP_HospitalIE.dbo.TrServiceHeader tsh 
	JOIN OLTP_HospitalIE.dbo.MsCustomer mc ON mc.CustomerID = tsh.CustomerID
	JOIN OLTP_HospitalIE.dbo.TrServiceDetail  tsd ON tsd.ServiceID = tsh.ServiceID
	JOIN OLTP_HospitalIE.dbo.MsDoctor md ON md.DoctorID = tsh.DoctorID
	JOIN DoctorDimension docdim ON docdim.DoctorID = tsh.DoctorID
	JOIN TreatmentDimension treatdim ON treatdim.TreatmentID = tsd.TreatmentID
	JOIN CustomerDimension cusdim ON cusdim.CustomerID = mc.CustomerID
	JOIN TimeDimension timedim ON timedim.Date = tsh.ServiceDate

GROUP BY CustomerCode, TreatmentCode, DoctorCode, TimeCode
END

-- Query Execution

 IF EXISTS(
	SELECT * 
	FROM FilterTimeStamp WHERE TableName = 'ServiceFact'
 )
 BEGIN 
	UPDATE FilterTimeStamp
	SET LastETL = GETDATE()
	WHERE TableName ='ServiceFact'
 END
 ELSE
 BEGIN
	INSERT INTO FilterTimeStamp VALUES ('ServiceFact', GETDATE())
 END
