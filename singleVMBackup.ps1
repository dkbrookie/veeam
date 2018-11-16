## Load Veeam snapin
asnp VeeamPSSnapin -EA 0

## User Input
$jobName = Read-Host "Enter Job Name"
$vmName = Read-Host "Enter VM Name"

## Find the job that has our VM
$job = Get-VBRJob | ?{$_.Name -eq $jobName}

## Get all objects in job apart from our target VM
$execObjs = $job.GetObjectsInJob() | ?{$_.Name -ne $vmName}

## Exclude the objects from the job(*Note: this isn't removing the objects from the job)
Remove-VBRJobObject -Job $job -Objects $execObjs

## Start the job only backing upi the target VM
Start-VBRJob -Job $job

## Find the exclude job objects
$incObjs = $job | Get-VBRJobObject | ?{$_.Type -eq "Exclude"}

## Delete the exclude objects(*Note: this tells VBR to include them again
foreach ($obj in $incObjs) {
	$obj.Delete()
}
