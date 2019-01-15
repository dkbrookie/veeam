/*
.Automate Monitor Name
*DKBA - BACKUP - Veeam - Backup Agent Installed / Install VAC Agent

.Description
Finds all machines with Veeam Agent installed that do not have the VAC agent installed. This is used to trigger the install of the VAC
Agent so we can control all Veeam Agents from our central management portal.
*/

SELECT DISTINCT
  'Missing VAC Agent' AS TestValue,
  CONCAT(cl.Name," - ",c.Name) AS IdentityField,
  s.ComputerID,
  acd.NoAlerts,
  acd.UpTimeStart,
  acd.UpTimeEnd
FROM
  computers c
JOIN
  software s
  ON s.`ComputerID` = c.`ComputerID`
JOIN
  clients cl
  ON c.ClientID = cl.ClientID
JOIN
  AgentComputerData acd
  ON acd.`ComputerID` = c.`ComputerID`
WHERE
  s.Name = 'Veeam Agent for Microsoft Windows'
  AND c.LastContact > DATE_ADD(NOW(),INTERVAL -15 MINUTE)
  AND OS LIKE '%server%'
  AND c.LocationID <> 1
  AND s.ComputerID NOT IN (
    SELECT computerid
    FROM software
    WHERE NAME = 'Veeam Availability Console Communication Agent'
  )
