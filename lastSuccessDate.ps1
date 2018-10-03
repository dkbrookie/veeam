<#
Pulls the latest successful backup date for Veeam Agent
#>
$lastSuccess = Get-EventLog "Veeam Agent" -InstanceId 190 -Newest 1 -EntryType Information -ErrorAction SilentlyContinue
$lastSuccess.TimeGenerated
