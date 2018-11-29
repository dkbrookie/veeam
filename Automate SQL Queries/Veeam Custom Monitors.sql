/*Veeam - Failed Backup Monitor*/
SELECT j.status AS TestValue, 
v.vm_name AS IdentityField, 
acd.computerid AS ComputerID, 
acd.NoAlerts, 
acd.UpTimeStart, 
acd.UpTimeEnd FROM plugin_veeam_lbp_protected_vms AS v 
INNER JOIN plugin_veeam_lbp_job AS j 
ON v.job_uid = j.id 
LEFT OUTER JOIN computers AS c 
ON v.server_name = c.name 
LEFT OUTER JOIN AgentComputerData AS acd 
ON c.computerid = acd.computerid 
WHERE j.status = 2 
AND j.type = 0 
AND v.next_run_time <> '' 
AND v.vm_name <> '0'


/*Veeam - Failed Replication Monitor*/
SELECT j.status AS TestValue, 
v.vm_name AS IdentityField, 
acd.computerid AS ComputerID, 
acd.NoAlerts, 
acd.UpTimeStart, 
acd.UpTimeEnd FROM plugin_veeam_lbp_protected_vms AS v 
INNER JOIN plugin_veeam_lbp_job AS j 
ON v.job_uid = j.id 
LEFT OUTER JOIN computers AS c 
ON v.server_name = c.name 
LEFT OUTER JOIN AgentComputerData AS acd 
ON c.computerid = acd.computerid 
WHERE j.status = 2 
AND j.type = 1 
AND v.next_run_time <> '' 
AND v.vm_name <> '0'


/*Veeam - Failed Copy Monitor*/
SELECT j.status AS TestValue, 
v.vm_name AS IdentityField, 
acd.computerid AS ComputerID, 
acd.NoAlerts, 
acd.UpTimeStart, 
acd.UpTimeEnd FROM plugin_veeam_lbp_job AS j 
INNER JOIN plugin_veeam_lbp_protected_vms AS v 
ON v.server_id = j.server_id
LEFT OUTER JOIN computers AS c 
ON v.server_name = c.name 
LEFT OUTER JOIN AgentComputerData AS acd 
ON c.computerid = acd.computerid 
WHERE j.status = 2 
AND j.type = 51 
AND v.vm_name <> '0'
AND c.clientid <> 1
GROUP BY v.vm_name


/*Veeam - Failed Backup Monitor*/
SELECT j.status AS TestValue, 
v.vm_name AS IdentityField, 
acd.computerid AS ComputerID, 
acd.NoAlerts, 
acd.UpTimeStart, 
acd.UpTimeEnd FROM plugin_veeam_lbp_protected_vms AS v 
INNER JOIN plugin_veeam_lbp_job AS j 
ON v.job_uid = j.id 
LEFT OUTER JOIN computers AS c 
ON v.server_name = c.name 
LEFT OUTER JOIN AgentComputerData AS acd 
ON c.computerid = acd.computerid 
WHERE j.status = 3 
AND j.type = 0 
AND v.next_run_time <> '' 
AND v.vm_name <> '0'

SELECT * FROM plugin_veeam_lbp_job



/* Reset Veeam Failed Backup Job Tickets / Vars */
DELETE FROM runningscripts WHERE ScriptID = 6463;
DELETE FROM scriptstate WHERE ScriptID = 6463;
DELETE FROM scheduledscripts WHERE ScriptID = 6463;
UPDATE tickets SET STATUS = 4 WHERE SUBJECT LIKE '%Veeam B&R | Failed Backup%' AND STATUS IN (1,2);
/* Check Veeam Failed Backup Job Tickets / Vars */
SELECT * FROM tickets WHERE SUBJECT LIKE '%Veeam B&R | Failed Backup%' AND STATUS IN (1,2);
SELECT * FROM scriptstate WHERE ScriptID = 6463;



/* Reset Veeam Replication Job Tickets / Vars */
DELETE FROM runningscripts WHERE ScriptID = 6473;
DELETE FROM scriptstate WHERE ScriptID = 6473;
DELETE FROM scheduledscripts WHERE ScriptID = 6473;
UPDATE tickets SET STATUS = 4 WHERE SUBJECT LIKE '%Veeam B&R | Failed Replication%' AND STATUS IN (1,2);
/* Check Veeam Replication Job Tickets / Vars */
SELECT * FROM tickets WHERE SUBJECT LIKE '%Veeam B&R | Failed Replication%' AND STATUS IN (1,2);
SELECT * FROM scriptstate WHERE ScriptID = 6473;
SELECT COUNT(*) FROM scriptstate WHERE scriptID = 6473 AND VALUE <> 0;


/* Reset Veeam Copy Job Tickets / Vars */
DELETE FROM runningscripts WHERE ScriptID = 6474;
DELETE FROM scriptstate WHERE ScriptID = 6474;
DELETE FROM scheduledscripts WHERE ScriptID = 6474;
UPDATE tickets SET STATUS = 4 WHERE SUBJECT LIKE '%Veeam B&R | Failed Copy Job%' AND STATUS IN (1,2);
/* Check Veeam Copy Job Tickets / Vars */
SELECT * FROM tickets WHERE SUBJECT LIKE '%Veeam B&R | Failed Copy Job%' AND STATUS IN (1,2);
SELECT * FROM scriptstate WHERE ScriptID = 6474;
SELECT COUNT(*) FROM scriptstate WHERE scriptID = 6474 AND VALUE <> 0;


/* Reset Veeam WA Failed Backup Job Tickets / Vars */
DELETE FROM runningscripts WHERE ScriptID = 6471;
DELETE FROM scriptstate WHERE ScriptID = 6471;
DELETE FROM scheduledscripts WHERE ScriptID = 6471;
UPDATE tickets SET STATUS = 4 WHERE SUBJECT LIKE '%Veeam EP | Failed Backup%' AND STATUS IN (1,2);
/* Check Veeam WA Failed Backup Job Tickets / Vars */
SELECT * FROM tickets WHERE SUBJECT LIKE '%Veeam EP | Failed Backup%' AND STATUS IN (1,2);
SELECT * FROM scriptstate WHERE ScriptID = 6471;






/* V2 */

/*Veeam - Failed Backup Monitor*/
SELECT j.status AS TestValue, 
CONCAT('Veeam Backup Job failed: ',v.vm_name,' on ',v.server_name) AS IdentityField,
acd.computerid AS ComputerID, 
acd.NoAlerts, 
acd.UpTimeStart, 
acd.UpTimeEnd FROM plugin_veeam_lbp_protected_vms AS v 
INNER JOIN plugin_veeam_lbp_job AS j 
ON v.job_uid = j.id 
LEFT OUTER JOIN computers AS c 
ON v.server_name = c.name 
LEFT OUTER JOIN AgentComputerData AS acd 
ON c.computerid = acd.computerid 
WHERE j.status = 2 
AND j.type = 0 
AND v.next_run_time <> '' 


/*Veeam - Failed Replication Monitor*/
SELECT j.status AS TestValue, 
CONCAT('Veeam Replication Job failed: ',v.vm_name,' on ',v.server_name) AS IdentityField,
acd.computerid AS ComputerID, 
acd.NoAlerts, 
acd.UpTimeStart, 
acd.UpTimeEnd FROM plugin_veeam_lbp_protected_vms AS v 
INNER JOIN plugin_veeam_lbp_job AS j 
ON v.job_uid = j.id 
LEFT OUTER JOIN computers AS c 
ON v.server_name = c.name 
LEFT OUTER JOIN AgentComputerData AS acd 
ON c.computerid = acd.computerid 
WHERE j.status = 2 
AND j.type = 1 
AND v.next_run_time <> '' 


/*Veeam - Failed Copy Monitor*/
SELECT j.status AS TestValue, 
CONCAT('Veeam Copy Job failed: ',v.vm_name,' on ',v.server_name) AS IdentityField,
acd.computerid AS ComputerID, 
acd.NoAlerts, 
acd.UpTimeStart, 
acd.UpTimeEnd FROM plugin_veeam_lbp_job AS j 
INNER JOIN plugin_veeam_lbp_protected_vms AS v 
ON v.server_id = j.server_id
LEFT OUTER JOIN computers AS c 
ON v.server_name = c.name 
LEFT OUTER JOIN AgentComputerData AS acd 
ON c.computerid = acd.computerid 
WHERE j.status = 2 
AND j.type = 51 
GROUP BY v.vm_name



######
##V3##
######

################################
##Veeam Failed Backup - By Job##
################################
SELECT 
	CASE
		WHEN (vj.status = 2) THEN 'Backup Failed'
	END AS 'TestValue',
	CONCAT(c.name, ", Job Name: ",vj.name) AS IdentityField, 
	acd.computerid AS ComputerID, 
	acd.NoAlerts, 
	acd.UpTimeStart, 
	acd.UpTimeEnd,
	vp.vm_name 
FROM 
	plugin_veeam_lbp_job AS vj 
	LEFT OUTER JOIN plugin_veeam_lbp_protected_vms AS vp
		ON vp.server_id = vj.server_id
	LEFT JOIN computers AS c 
		ON vp.server_name = c.name 
	LEFT OUTER JOIN AgentComputerData AS acd 
		ON c.computerid = acd.computerid 
WHERE 
	vj.status = 2 
	AND vj.type IN (52,0)
GROUP BY 
	c.name

##############################
##Veeam Failed Copy - By Job##
##############################
SELECT 
	CASE
		WHEN (vj.status = 2) THEN 'Copy Job Failed'
	END AS 'TestValue',
	CONCAT(c.name, ", Job Name: ",vj.name) AS IdentityField, 
	acd.computerid AS ComputerID, 
	acd.NoAlerts, 
	acd.UpTimeStart, 
	acd.UpTimeEnd 
FROM 
	plugin_veeam_lbp_job AS vj 
	LEFT OUTER JOIN plugin_veeam_lbp_protected_vms AS vp
		ON vp.server_id = vj.server_id
	LEFT JOIN computers AS c 
		ON vp.server_name = c.name 
	LEFT OUTER JOIN AgentComputerData AS acd 
		ON c.computerid = acd.computerid 
WHERE 
	vj.status = 2 
	AND vj.type = 51
GROUP BY 
	c.name


#####################################
##Veeam Failed Replication - By Job##
#####################################
SELECT 
	CASE
		WHEN (vj.status = 2) THEN 'Replication Failed'
	END AS 'TestValue',
	CONCAT(c.name, ", Job Name: ",vj.name) AS IdentityField, 
	acd.computerid AS ComputerID, 
	acd.NoAlerts, 
	acd.UpTimeStart, 
	acd.UpTimeEnd 
FROM 
	plugin_veeam_lbp_job AS vj 
	LEFT OUTER JOIN plugin_veeam_lbp_protected_vms AS vp
		ON vp.server_id = vj.server_id
	LEFT JOIN computers AS c 
		ON vp.server_name = c.name 
	LEFT OUTER JOIN AgentComputerData AS acd 
		ON c.computerid = acd.computerid 
WHERE 
	vj.status = 2 
	AND vj.type = 1
GROUP BY 
	c.name
	


	
	
	
	
	
	
SELECT 
	failure_message 
FROM 
	plugin_veeam_lbp_jobsession 
WHERE 
	job_id = (SELECT 
			job_uid 
		FROM 
			plugin_veeam_lbp_protected_vms 
		WHERE 
			vm_name = 'dkbveeamcloud' 
			AND failure_message != '' LIMIT 1) 
ORDER BY 
	start_time DESC 
LIMIT 
	1



	
SELECT
	pv.server_name AS 'Veeam B&R Server',
	pv.vm_name AS 'Machine Name',  
	js.failure_message AS 'Failure Message',
	js.start_time AS 'Job Start Time', 
	js.duration AS 'Job Duration (in minutes)'
FROM
	plugin_veeam_lbp_jobsession js
JOIN
	plugin_veeam_lbp_protected_vms pv
		ON js.job_id = pv.job_uid
WHERE
	pv.vm_name = 'oemdp2'
ORDER BY 
	js.start_time DESC
LIMIT
	10
	
	
	
	
	


SELECT
	pv.vm_name AS 'Machine Name',  
	js.job_id AS 'Job ID'
FROM
	plugin_veeam_lbp_jobsession js
JOIN
	plugin_veeam_lbp_protected_vms pv
		ON js.job_id = pv.job_uid
JOIN
	plugin_veeam_lbp_job AS vj 
		ON pv.job_uid = vj.id
WHERE
	vj.status = 2 
	AND vj.type IN (52,0)
GROUP BY
	pv.vm_name
ORDER BY 
	js.start_time DESC;
	
	
	
	
	
SELECT * FROM groupdagents WHERE NAME = 'Veeam B&R - Failed Copy - By Job'

SELECT `name` FROM plugin_veeam_lbp_job WHERE id = '49508d39-3b48-43d4-8d3e-8e32e5c4c3bb'