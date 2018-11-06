### LABTECH START ###

$outputfile = "Inventory.html"

#Delete last instance of this report.
del $outputfile -ErrorAction SilentlyContinue

add-pssnapin veeampssnapin

### GETTING ALL THE THINGS ###
$today = get-date
$timespan = (get-date).adddays(-7)
$server = get-vbrserversession | select-object -expandproperty server

### MAKE THE ARRAYS ###
$JobInventory = @()
$RepositoryInventory = @()
$CloudInventory = @()
$TaskInventory = @()


### FORMAT THE HTML ###
$Header = @"
<style>
TABLE {border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
TH {white-space: nowrap; border-width: 1px;padding: 3px;border-style: solid;border-color: black; font-family: Tahoma;font-size: 12px; background-color: #00B050; }
TD {border-width: 1px;padding: 3px;border-style: solid;border-color: black; font-family: Tahoma;font-size: 11px; white-space: nowrap;}
</style>
"@

### STARTING JOB INVENTORY ###
$jobs = get-vbrjob  | sort-object name
foreach ($job in $jobs) {
    $jobtype = $job.jobtype
    $JobAlgorithm = $job.findlastsession().info.jobalgorithm
    $jobduration = $job.findlastsession().progress.duration
    $TargetHostID = $job.info.targetrepositoryid.guid
    $repository = Get-VBRBackupRepository | where-object {$_.ID -eq $TargetHostID}
    $JobInventory += New-Object PSobject -Property @{
    'Name' = $job.name
    'Type' = "$jobtype $jobalgorithm"
    'Repository' = $repository.name
    'Start Time' = $job.findlastsession().progress.starttime
    'End Time' = $job.findlastsession().progress.stoptime
    'Duration' = $jobduration.ToString("hh\:mm\:ss") }
$JobHTML = $JobInventory | select-object "Name", "Type", "Start Time", "End Time", "Duration", "Repository"  | ConvertTo-HTML -fragment
}

### STARTING BACKUP REPOSITORY INVENTORY ###
$repositories = Get-VBRBackupRepository | sort-object name
foreach ($repository in $repositories) {
    $path = $repository.friendlypath
    $cloud = $repository.cloudprovider.hostname
    $capacity = ($repository.info.CachedTotalSpace) / 1GB
    $capacity = "{0:N0}" -f $capacity
    $freespaceGB = ($repository.info.CachedFreeSpace) / 1GB
    $freespaceGB = "{0:N0}" -f $freespaceGB
    $RepositoryInventory += New-Object PSobject -Property @{
    'Name' = $repository.name
    'Type' = $repository.typedisplay
    'Path' = "$path $cloud"
    'Capacity GB' = $capacity
    'Free Space GB' = $freespaceGB
    'Description' = $repository.description}
$RepositoryHTML = $RepositoryInventory | select-object "Name", "Type", "Path", "Capacity GB", "Free Space GB", "Description" | ConvertTo-HTML -fragment
}



### STARTING TASKS INVENTORY ###
$sessions = get-vbrbackupsession | where-object {$_.creationtime -ge $timespan}
$tasks = $sessions.gettasksessions() | sort-object name, {$_.jobsess.creationtime}

foreach ($task in $tasks) {
    $duration = new-timespan -start $task.jobsess.creationtime -end $task.jobsess.endtime
    $MBs = ($task.progress.avgspeed / 1MB)
    $TransferredGB = $task.progress.transferedsize / 1GB
    $TaskInventory += New-Object PSobject -Property @{
    'Name' = $task.name
    'Status' = $task.status
    'Start Time' = $task.jobsess.creationtime
    'End Time' = $task.jobsess.endtime
    'SizeGB' = "{0:N2}" -f $TransferredGB
    'Duration' = $duration.ToString("hh\:mm\:ss")
    'MB/s' = "{0:N3}" -f $MBs
    'Details' = $task.info.reason

}
$TaskHTML = $TaskInventory | select-object Name, Status, "Start Time", "End Time", SizeGB, Duration, 'MB/s', Details | ConvertTo-HTML -fragment
}

### BUILDING REPORT ###

ConvertTo-HTML -head $header -body "<center><H1>$server Weekly Backup Report</H1>$timespan - $today</center><P>

<H2>Backup Repositories</H2>$RepositoryHTML<P>

<H2>Backup Jobs</H2>$JobHTML<P>

<H2>Backup Tasks</H2>$TaskHTML<P>


" | Out-file C:\Inventory.html
