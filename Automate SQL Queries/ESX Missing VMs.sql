/*******************************************************************
-Auth: Matthew Weir
-Date: 5/15/2018
-Description: This queries all ESX VMs that are detected through
VMM in Automate that do not have an agent installed.
**************************
-Change History
**************************
Date					Author		Description
-----------		-------		------------------------------------
-05/15/2018		Matthew		Added notes and cleaned up syntax
********************************************************************/

SELECT
	CASE
		WHEN (LEFT(esx.DNSValue,LOCATE('.',esx.DNSValue) - 1) = '') THEN esx.VmName
		ELSE LEFT(esx.DNSValue,LOCATE('.',esx.DNSValue) - 1)
		END AS 'ESX-VMName',
	IF(esx.PowerState = 1,'On','Off') AS 'Power State'
FROM
	plugin_vm_esxvirtualmachines esx
LEFT JOIN
	inv_networkcard nic
	ON esx.MacAddresses = nic.MAC
LEFT JOIN
	computers c
	ON LEFT(esx.DNSValue,LOCATE('.',esx.DNSValue) - 1) = c.Name
WHERE
	esx.MacAddresses <> ''
	AND c.ComputerID IS NULL
