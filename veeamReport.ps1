Function Veeam-BackupReport {
  <#
    .SYNOPSIS
    Veeam-BackupReport

    .DESCRIPTION
    Veeam-BackupReport will generate a report at C:\VeeamBackupReport.html with detailed results for all jobs completed in the number
    of days you specify in the Days parameter.

    .PARAMETER Days
    Specify how many days worth of backups you want to generate the report for.

    .EXAMPLE
    C:\PS> Veeam-BackupReport -Days 30
  #>

  [CmdletBinding()]

  Param(
    [Parameter(Mandatory = $True)]
    [string]$Days
  )

  ## Variable Set Prep
  Add-PsSnapin veeampssnapin
  $today = Get-Date
  $timeSpan = (Get-Date).adddays(-$Days)
  $server = Get-Vbrserversession | Select-Object -ExpandProperty server
  $outputFile = "C:\VeeamBackupReport.html"

  ## Delete last instance of this report
  del $outputFile -ErrorAction SilentlyContinue

  ## Create arrays
  $JobInventory = @()
  $RepositoryInventory = @()
  $CloudInventory = @()
  $TaskInventory = @()

## Format HTML
$Header = @"
<style>
TABLE {border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
TH {white-space: nowrap; border-width: 1px;padding: 3px;border-style: solid;border-color: black; font-family: Tahoma;font-size: 12px; background-color: #00B050; }
TD {border-width: 1px;padding: 3px;border-style: solid;border-color: black; font-family: Tahoma;font-size: 11px; white-space: nowrap;}
</style>
"@
  ## Start job inventory
  $jobs = Get-VBRJob  | Sort-Object name
  ForEach ($job in $jobs) {
    $jobtype = $job.jobtype
    $JobAlgorithm = $job.findlastsession().info.jobalgorithm
    $jobduration = $job.findlastsession().progress.duration
    $TargetHostID = $job.info.targetrepositoryid.guid
    $repository = Get-VBRBackupRepository | Where-Object {$_.ID -eq $TargetHostID}
    $JobInventory += New-Object PSobject -Property @{
      'Name' = $job.name
      'Type' = "$jobtype $jobalgorithm"
      'Repository' = $repository.name
      'Start Time' = $job.findlastsession().progress.starttime
      'End Time' = $job.findlastsession().progress.stoptime
      'Duration' = $jobduration.ToString("hh\:mm\:ss")
    }
  $JobHTML = $JobInventory | Select-Object "Name", "Type", "Start Time", "End Time", "Duration", "Repository"  | ConvertTo-HTML -Fragment
  }

  ## Start backup repository inventory
  $repositories = Get-VBRBackupRepository | Sort-Object name
  ForEach ($repository in $repositories) {
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
      'Description' = $repository.description
    }
  $RepositoryHTML = $RepositoryInventory | Select-Object "Name", "Type", "Path", "Capacity GB", "Free Space GB", "Description" | ConvertTo-HTML -Fragment
  }

  ## Start task inventory
  $sessions = Get-VBRBackupsession | Where-Object {$_.creationtime -ge $timeSpan}
  $tasks = $sessions.gettasksessions() | Sort-Object name, {$_.jobsess.creationtime}

  ForEach ($task in $tasks) {
    $duration = New-Timespan -start $task.jobsess.creationtime -end $task.jobsess.endtime
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
  $TaskHTML = $TaskInventory | Select-Object Name, Status, "Start Time", "End Time", SizeGB, Duration, 'MB/s', Details | ConvertTo-HTML -Fragment
  }

  ## Build the report
  ConvertTo-HTML -head $header -body "<center><H1>$server Backup Report</H1>$timeSpan - $today</center><P>

  <H2>Backup Repositories</H2>$RepositoryHTML<P>

  <H2>Backup Jobs</H2>$JobHTML<P>

  <H2>Backup Tasks</H2>$TaskHTML<P>


  " | Out-file $outputFile
}
