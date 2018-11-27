/*Query for BrightGauge*/
SELECT
  CASE
    WHEN c.OS LIKE '%R2%' OR c.OS LIKE '%2016%' OR c.OS LIKE '%2012%' THEN 'Missing Veeam Agent'
    ELSE 'Missing StorageCraft ShadowProtect SPX'
    END AS 'TestValue',
  c.ComputerID AS 'id',
  c.Name AS 'Identity Field',
  c.ComputerID AS 'ComputerID',
  cl.Name AS 'Client',
  c.Name,
  c.OS,
  c.BiosMFG AS 'Manufacturer',
  c.BiosName AS 'Model',
  c.BiosVer AS 'Serial',
  acd.NoAlerts,
  acd.UpTimeStart,
  acd.UpTimeEnd
FROM
  computers c
JOIN
  clients cl
  ON c.ClientID = cl.ClientID
JOIN
  AgentComputerData acd
  ON acd.ComputerID = c.ComputerID
WHERE
  c.OS LIKE '%server%'
  AND c.OS LIKE '%windows%'
  AND c.BiosName NOT LIKE '%Virtual%'
  AND c.BiosName <> ''
  AND c.BiosName NOT LIKE '%vmware%'
  AND c.BiosName <> 'KVM'
  AND c.ComputerID NOT IN (SELECT ComputerID FROM software WHERE `Name` = 'Veeam Agent for Microsoft Windows' OR `Name` = 'StorageCraft ShadowProtect SPX')
  AND c.LocationID <> 1
GROUP BY
  c.ComputerID;


/*Query for the Automate monitor*/
  SELECT
    CASE
      WHEN c.OS LIKE '%R2%' OR c.OS LIKE '%2016%' OR c.OS LIKE '%2012%' THEN 'Missing Veeam Agent'
      ELSE 'Missing StorageCraft ShadowProtect SPX'
      END AS 'TestValue',
    c.Name AS 'Identity Field',
    c.ComputerID AS 'ComputerID',
    acd.NoAlerts,
    acd.UpTimeStart,
    acd.UpTimeEnd
  FROM
    computers c
  JOIN
    AgentComputerData acd
    ON acd.ComputerID = c.ComputerID
  WHERE
    c.OS LIKE '%server%'
    AND c.OS LIKE '%windows%'
    AND c.BiosName NOT LIKE '%Virtual%'
    AND c.BiosName <> ''
    AND c.BiosName NOT LIKE '%vmware%'
    AND c.BiosName <> 'KVM'
    AND c.ComputerID NOT IN (SELECT ComputerID FROM software WHERE `Name` = 'Veeam Agent for Microsoft Windows' OR `Name` = 'StorageCraft ShadowProtect SPX')
    AND c.LocationID <> 1
  GROUP BY
    c.ComputerID;
