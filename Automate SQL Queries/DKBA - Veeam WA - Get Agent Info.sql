/*
Last Successful backup EDF is ID 767
Last Job Out Message is ID 768
*/

SELECT
	edf.Value AS TestValue,
	c.Name AS IdentityField,
	edf.ID AS 'ComputerID',
	acd.NoAlerts,
	acd.UpTimeStart,
	acd.UpTimeEnd
FROM
	extrafielddata edf
JOIN
	computers c
	ON edf.ID = c.ComputerID
JOIN
	AgentComputerData acd
	ON acd.ComputerID = c.ComputerID
WHERE
	edf.ExtraFieldID = 767
	AND c.LastContact > DATE_ADD(NOW(),INTERVAL -15 MINUTE)
