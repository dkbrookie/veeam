SELECT
    CASE
      WHEN (vj.status = 2) THEN CONCAT('Replication Failed:', vj.name)
      END AS 'TestValue',
    vj.id AS IdentityField,
    acd.computerid AS ComputerID,
    acd.NoAlerts,
    acd.UpTimeStart,
    acd.UpTimeEnd FROM plugin_veeam_lbp_job AS vj
LEFT OUTER JOIN
    plugin_veeam_lbp_protected_vms AS vp
    ON vp.server_id = vj.server_id
LEFT JOIN
    computers AS c
    ON vp.server_name = c.name
LEFT OUTER JOIN
    AgentComputerData AS acd
    ON c.computerid = acd.computerid
WHERE
    vj.status = 2
    AND vj.type = 1
GROUP BY
    c.name
