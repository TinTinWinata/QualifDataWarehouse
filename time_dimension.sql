
-- Testing

SELECT * FROM TimeDimension
SELECT * FROM FilterTimeStamp

-- Time Dimension SELECT 
IF EXISTS(
	SELECT * 
	FROM OLAP_HospitallE..FilterTimeStamp
	WHERE TableName = 'TimeDimension'
)
 BEGIN 
	SELECT
	[Date] = x.Date,
	[Day] = DAY(x.Date),
	[Month] = MONTH(x.Date),
	[Quarter] = DATEPART(QUARTER, x.Date),
	[Year] = YEAR(x.Date)
	FROM (
		SELECT
		PurchaseDate AS [Date]
		FROM
		OLTP_HospitalIE..TrPurchaseHeader
		UNION
		SELECT
		SalesDate AS [Date]
		FROM
		OLTP_HospitalIE..TrSalesHeader
		UNION
		SELECT
		SubscriptionStartDate
		FROM
		OLTP_HospitalIE..TrSubscriptionHeader
		UNION
		SELECT
		ServiceDate
		FROM
		OLTP_HospitalIE..TrServiceHeader
	) AS x
	WHERE [Date] > (
					SELECT 
					LastETL
					FROM OLAP_HospitallE..FilterTimeStamp
					WHERE TableName = 'TimeDimension'
					)

 END
 ELSE
 BEGIN
	SELECT
	[Date] = x.Date,
	[Day] = DAY(x.Date),
	[Month] = MONTH(x.Date),
	[Quarter] = DATEPART(QUARTER, x.Date),
	[Year] = YEAR(x.Date)
	FROM (
		SELECT
		PurchaseDate AS [Date]
		FROM
		OLTP_HospitalIE..TrPurchaseHeader
		UNION
		SELECT
		SalesDate AS [Date]
		FROM
		OLTP_HospitalIE..TrSalesHeader
		UNION
		SELECT
		SubscriptionStartDate
		FROM
		OLTP_HospitalIE..TrSubscriptionHeader
		UNION
		SELECT
		ServiceDate
		FROM
		OLTP_HospitalIE..TrServiceHeader
	) AS x
 END


 -- Inserting and Updating QUERY

 IF EXISTS(
	SELECT * 
	FROM FilterTimeStamp WHERE TableName = 'TimeDimension'
 )
 BEGIN 
	UPDATE FilterTimeStamp
	SET LastETL = GETDATE()
	WHERE TableName ='TimeDimension'
 END
 ELSE
 BEGIN
	INSERT INTO FilterTimeStamp VALUES ('TimeDimension', GETDATE())
 END


 DELETE FROM FilterTimeStamp

 SELECT * FROM TimeDimension

 SELECT * FROM FilterTimeStamp
