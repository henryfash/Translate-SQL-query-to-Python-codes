
With BusinessPartner AS
(
	SELECT 
		NULLIF(Replace(LTRIM(Replace([BusinessPartner],'0',' ')),' ','0'),'') AS BusinessPartnerID ,
		[BusinessPartnerDesc],
		[DomicileState]
	FROM 
	(\\BusinessPartner.csv) AS BusinessPartner 
)

SELECT
		[Treaty],
		[Section],
		MIN([TreatyPeriodStartDate]) As RelationshipStartDate,
		Count([UnderwritingYear]) As NoOfYears,
		[BusinessPartnerID] + ' - ' + [BusinessPartnerDesc] As BusinessPartner,
		[NatureOfTreaty],
		[Region],
		[DomicileState]
FROM
(
	SELECT
		TH.[Treaty],
		TS.[Section],
		TS.[TreatyPeriodStartDate],
		TS.[UnderwritingYear],
		TH.[BusinessPartnerID],
		TH.[NatureOfTreaty],
		ISNULL(BP.[BusinessPartnerDesc],'Partner Unknown') AS [BusinessPartnerDesc],
		CASE 
			WHEN BP.[DomicileState] in ('NY','FL','VT') THEN 'East Coast'
			WHEN BP.[DomicileState] in ('CA','OR') THEN 'West Coast'
			ELSE 'Other' 
		END As [Region],
		BP.[DomicileState]
	FROM 
	(\\Treaty.csv) As TH 
	INNER JOIN
	(\\TreatyPeriod.csv) As TP
		ON
		TH.[Treaty] = TP.Treaty
	INNER JOIN
	(\\TreatySection.csv) ) As TS
		ON
		TP.[Treaty] = TS.Treaty
		AND TP.[TreatyPeriodStartDate] = TS.[TreatyPeriodStartDate]
	LEFT OUTER JOIN
	BusinessPartner As BP
		ON
		TH.BusinessPartnerID = BP.BusinessPartnerID
	WHERE TS.Section != '-99' and TP.[TreatyPeriodStartDate] > '1800-01-01'
) MyBusiness
GROUP BY
		[Treaty],
		[Section],
		[BusinessPartnerID],
		[BusinessPartnerDesc],
		[NatureOfTreaty],
		[Region],
		[DomicileState]


