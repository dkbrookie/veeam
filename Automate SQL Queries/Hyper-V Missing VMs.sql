/*******************************************************************
-Auth: Matthew Weir
-Date: 5/15/2018
-Description: This queries all Hyper-V VMs that are detected through
VMM in Automate that do not have an agent installed.
**************************
-Change History
**************************
Date					Author		Description
-----------		-------		------------------------------------
-06/13/2018		Matthew		Added notes and cleaned up syntax
********************************************************************/

SELECT
	cl.Name AS 'Client',
	CASE
		WHEN (LEFT(hv.FQDN,LOCATE('.',hv.FQDN) - 1) = '') THEN hv.VMName
		ELSE LEFT(hv.FQDN,LOCATE('.',hv.FQDN) - 1)
		END AS 'Hyper-V-VMName',
	IF(hv.VMState = 2,'On','Off') AS 'Power State'
FROM
	plugin_vm_hvvirtualmachines hv
LEFT JOIN
	inv_networkcard nic
	ON hv.MacAddress = nic.MAC
LEFT JOIN
	computers c
	ON hv.HostComputerID = c.ComputerID
LEFT JOIN
	clients cl
	ON c.ClientID = cl.ClientID
WHERE
	nic.ComputerID IS NULL
	AND hv.MacAddress <> ''
