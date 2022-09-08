

-- Fact Subscription Get Data

USE OLAP_HospitallE


IF EXISTS(
	SELECT * 
	FROM FilterTimeStamp
	WHERE TableName = 'SubscriptionFact'
)

BEGIN
SELECT 
	StaffCode,
	CustomerCode,
	BenefitCode,
	TimeCode,
    [Total Subscription Earning] = SUM(mb.BenefitPrice),
    [Number Of Subscriber] = COUNT(tbh.CustomerID)
FROM
	OLTP_HospitalIE.dbo.MsBenefit mb 
	JOIN OLTP_HospitalIE.dbo.TrSubscriptionDetail tbd ON mb.BenefitID = tbd.BenefitID
	JOIN OLTP_HospitalIE.dbo.TrSubscriptionHeader tbh ON tbh.SubscriptionID = tbd.SubscriptionID
	JOIN CustomerDimension cusdim ON cusdim.CustomerID = tbh.CustomerID
	JOIN BenefitDimension bendim ON bendim.BenefitID = tbd.BenefitID
	JOIN StaffDimension staffdim ON staffdim.StaffID = tbh.StaffID
	JOIN TimeDimension timedim ON timedim.Date = tbh.SubscriptionStartDate
WHERE 
	tbh.SubscriptionStartDate > (
		SELECT LastETL FROM FilterTimeStamp
		WHERE TableName = 'SubscriptionFact'
	)
GROUP BY StaffCode, CustomerCode, BenefitCode, TimeCode

END

ELSE
BEGIN 
SELECT 
	StaffCode,
	CustomerCode,
	BenefitCode,
	TimeCode,
    [Total Subscription Earning] = SUM(mb.BenefitPrice),
    [Number Of Subscriber] = COUNT(tbh.CustomerID)
FROM
	OLTP_HospitalIE.dbo.MsBenefit mb 
	JOIN OLTP_HospitalIE.dbo.TrSubscriptionDetail tbd ON mb.BenefitID = tbd.BenefitID
	JOIN OLTP_HospitalIE.dbo.TrSubscriptionHeader tbh ON tbh.SubscriptionID = tbd.SubscriptionID
	JOIN CustomerDimension cusdim ON cusdim.CustomerID = tbh.CustomerID
	JOIN BenefitDimension bendim ON bendim.BenefitID = tbd.BenefitID
	JOIN StaffDimension staffdim ON staffdim.StaffID = tbh.StaffID
	JOIN TimeDimension timedim ON timedim.Date = tbh.SubscriptionStartDate
GROUP BY StaffCode, CustomerCode, BenefitCode, TimeCode
END

-- Query Execution

 IF EXISTS(
	SELECT * 
	FROM FilterTimeStamp WHERE TableName = 'SubscriptionFact'
 )
 BEGIN 
	UPDATE FilterTimeStamp
	SET LastETL = GETDATE()
	WHERE TableName ='SubscriptionFact'
 END
 ELSE
 BEGIN
	INSERT INTO FilterTimeStamp VALUES ('SubscriptionFact', GETDATE())
 END