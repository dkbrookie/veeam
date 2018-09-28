##Pull the latest success/fail/warning messages
$lastSuccessM = Get-EventLog "Veeam Agent" -InstanceId 190 -Newest 1 -EntryType Information -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Message
$lastFailM = Get-EventLog "Veeam Agent" -InstanceId 190 -Newest 1 -EntryType Error -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Message
$lastWarningM = Get-EventLog "Veeam Agent" -InstanceId 190 -Newest 1 -EntryType Warning -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Message

##Pull the latest event index IDs for Veeam Agent success/fail/warnings
$lastSuccessI = Get-EventLog "Veeam Agent" -InstanceId 190 -Newest 1 -EntryType Information -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Index
$lastFailI = Get-EventLog "Veeam Agent" -InstanceId 190 -Newest 1 -EntryType Error -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Index
$lastWarningI = Get-EventLog "Veeam Agent" -InstanceId 190 -Newest 1 -EntryType Warning -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Index

##Pull the latest succssful backup date
$lastSuccessD = Get-EventLog "Veeam Agent" -InstanceId 190 -Newest 1 -EntryType Information -ErrorAction SilentlyContinue | Select-Object -ExpandProperty TimeGenerated

##Determine which status was the most recent out of the previously pulled success/fail/warning Event ID indexes
$latestID = ($lastSuccessI,$lastFailI,$lastWarningI | Measure-Object -Maximum).Maximum

##If all log messages are blank, output the message below and then exit the script
IF(!$lastSuccessM -and !$lastFailM -and !$lastWarningM){
    Write-Output "No Veeam Agent logs could be found. This means no backups have been configured or completed."
    Break
}

##Output the lateast successful backup message
IF($latestID -eq $lastSuccessI){
    Write-Output "!SUCC01: "$lastSuccessM
}

##Output the latest failed backup message
IF($latestID -eq $lastFailI){
    Write-Output "!ERRFA01: "$lastFailM
    IF(!$lastSuccessD){
        Write-Output "There are no successful backups for this machines in the logs."
    }
    ELSE{
        Write-Output "Last Successful Backup: $lastSuccessD"
    }
}

##Output the latest backup warning message
IF($latestID -eq $lastWarningI){
    Write-Output "!ERRWAR01: " $lastWarningM
    IF(!$lastSuccessD){
        Write-Output "There are no successful backups for this machines in the logs."
    }
    ELSE{
        Write-Output "Last Successful Backup: $lastSuccessD"
    }
}
