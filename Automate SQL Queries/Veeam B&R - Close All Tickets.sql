/*Close all Veeam Failed Backup tickets*/
UPDATE scriptstate SET `Value` = 0 WHERE ScriptID = 6610
UPDATE tickets SET `Status` = 4 WHERE `Subject` LIKE '%Veeam B&R | Failed Backup%' AND `Status` <> 4;
/*View all Veeam Failed Backup tickets and script states*/
SELECT * FROM scriptstate WHERE ScriptID = 6610
SELECT * FROM tickets WHERE `Subject` LIKE '%Veeam B&R | Failed Backup%' AND `Status` <> 4;

/*Close all Veeam Failed Copy tickets*/
UPDATE scriptstate SET `Value` = 0 WHERE ScriptID = 6637
UPDATE tickets SET `Status` = 4 WHERE `Subject` LIKE '%Veeam B&R | Failed Copy%' AND `Status` <> 4;
/*View all Veeam Failed Copy tickets and script states*/
SELECT * FROM scriptstate WHERE ScriptID = 6637
SELECT * FROM tickets WHERE `Subject` LIKE '%Veeam B&R | Failed Copy%' AND `STATUS` <> 4;

/*Close all Veeam Failed Replication tickets*/
UPDATE scriptstate SET `Value` = 0 WHERE ScriptID = 6639
UPDATE tickets SET `Status` = 4 WHERE `Subject` LIKE '%Veeam B&R | Failed Replication%' AND `Status` <> 4;
/*View all Veeam Failed Replication tickets and script states*/
SELECT * FROM scriptstate WHERE ScriptID = 6639
SELECT * FROM tickets WHERE `Subject` LIKE '%Veeam B&R | Failed Replication%' AND `STATUS` <> 4;
