SELECT
  c.ComputerID AS 'id',
  cl.Name AS 'Client',
  c.Name,
  c.BiosMFG AS 'Manufacturer',
  c.BiosName AS 'Model',
  c.BiosVer AS 'Serial'
FROM
  computers c
JOIN
  clients cl
  ON c.ClientID = cl.ClientID
WHERE
  c.OS LIKE '%server%'
  AND c.BiosName NOT LIKE '%Virtual%'
  AND c.BiosName <> ''
  AND c.BiosName NOT LIKE '%vmware%'
  AND c.BiosName <> 'KVM'
  AND c.ComputerID NOT IN (SELECT ComputerID FROM software WHERE `Name` = 'Veeam Agent for Microsoft Windows' OR `Name` LIKE '%ShadowProtect%')
GROUP BY
  c.ComputerID
ORDER BY
  cl.Name,
  c.Name
