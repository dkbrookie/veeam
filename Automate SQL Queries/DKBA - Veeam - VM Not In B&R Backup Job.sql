SELECT
	hv.VMName AS TestValue,
	CONCAT('VM Host: ',c.Name) AS IdentityField,
	hv.HostComputerID AS ComputerID,
	acd.NoAlerts,
	acd.UpTimeStart,
	acd.UpTimeEnd
FROM
	plugin_vm_hvvirtualmachines hv
JOIN
	AgentComputerData acd
	ON acd.ComputerID = hv.HostComputerID
JOIN
	computers c
	ON hv.HostComputerID = c.ComputerID
WHERE
	hv.VMName NOT IN (SELECT v.VM_Name FROM	plugin_veeam_lbp_protected_vms v)
	AND hv.VMName NOT LIKE '%_replica%'
	AND hv.VMName NOT LIKE '%virtual_lab%'
UNION
SELECT
	esx.VMName AS TestValue,
	CONCAT('VM Host: ',esx.HostName) AS IdentityField,
	247 AS ComputerID,
	acd.NoAlerts,
	acd.UpTimeStart,
	acd.UpTimeEnd
FROM
	plugin_vm_esxvirtualmachines esx
JOIN
	AgentComputerData acd
	ON acd.ComputerID = 247
WHERE
	esx.VMName NOT IN (SELECT v.VM_Name FROM plugin_veeam_lbp_protected_vms v)
	AND esx.VMName NOT LIKE '%_replica%'
	AND esx.VMName NOT LIKE '%virtual_lab%'
