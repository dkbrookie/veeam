/*
Last Successful backup EDF is ID 767
Last Job Out Message is ID 768
*/

SELECT
	STR_TO_DATE(edf.Value, '%m/%d/%Y %k:%i:%S') AS TestValue,
	c.Name AS IdentityField,
	edf.ID AS 'ComputerID',
	acd.NoAlerts,
	acd.UpTimeStart,
	acd.UpTimeEnd,
	edf.Value
FROM
	extrafielddata edf
JOIN
	computers c
	ON edf.ID = c.ComputerID
JOIN
	AgentComputerData acd
	ON acd.ComputerID = c.ComputerID
JOIN
	software sw
	ON sw.ComputerID = edf.ID
WHERE
	edf.ExtraFieldID = 767
	AND edf.Value <> ''
	AND STR_TO_DATE(edf.Value, '%m/%d/%Y %k:%i:%S') <> '0000-00-00 00:00:00'
	AND STR_TO_DATE(edf.Value, '%m/%d/%Y %k:%i:%S') IS NOT NULL
	AND STR_TO_DATE(edf.Value, '%m/%d/%Y %k:%i:%S')  < DATE_ADD(NOW(),INTERVAL -3 DAY)
	AND edf.ID NOT IN (SELECT ID FROM extrafielddata WHERE ExtraFieldID = 747 AND `Value` = 1)
	AND sw.Name = 'Veeam Agent for Microsoft Windows'
