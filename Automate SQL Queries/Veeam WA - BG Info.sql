/*
Last Successful backup EDF is ID 767
Last Job Out Message is ID 768
*/

SELECT
	cl.Name AS 'Client',
	edf.ID AS 'id',
	c.Name AS 'Computer Name',
	STR_TO_DATE(edf.Value, '%m/%d/%Y %k:%i:%S') AS 'Last Successful Backup',
	sw.Version AS 'Veeam Version',
	CASE
		WHEN edf2.Value = 'OK' THEN 'No message found'
		ELSE edf2.Value
		END AS 'Last Message'
FROM
	extrafielddata edf
JOIN
	computers c
	ON edf.ID = c.ComputerID
JOIN
	software sw
	ON sw.ComputerID = edf.ID
JOIN
	clients cl
	ON cl.ClientID = c.ClientID
JOIN
	extrafielddata edf2
	ON edf2.ID = edf.ID
WHERE
	edf.ExtraFieldID = 767
	AND edf2.ExtraFieldID = 768
	AND STR_TO_DATE(edf.Value, '%m/%d/%Y %k:%i:%S') IS NOT NULL
	AND STR_TO_DATE(edf.Value, '%m/%d/%Y %k:%i:%S')  < DATE_ADD(NOW(),INTERVAL -3 DAY)
	AND edf.ID NOT IN (SELECT ID FROM extrafielddata WHERE ExtraFieldID = 747 AND `Value` = 1)
	AND sw.Name = 'Veeam Agent for Microsoft Windows'
