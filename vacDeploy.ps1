
Try {
  If((Get-WmiObject win32_operatingsystem | Select-Object -ExpandProperty osarchitecture) -eq '64-bit') {
    $osVer = 'x64'
  } Else {
    $osVer = 'x86'
  }
} Catch {
  Write-Error 'Unable to determine OS architecture' | Out-File $logFile -Append
  Return
}

$agentDL = "URLHERE"
$dlDir = "$env:windir\LTSvc\packages\veeam\VACAgent"
$VACAgent = "$dlDir\VACAgent$osVer.zip"

If(!(Test-Path $dlDir)) {
  New-Item -ItemType Directory $dlDir
}

If(!(Test-Path $VACAgent -PathType Leaf)) {
  Start-BitsTransfer -Source HERE -Destination $VACAgent
}


msiexec /i c:\VAC.CommunicationAgent.x64.msi /qn CC_GATEWAY=veeam.dkbinnovative.com VAC_TENANT=DKB VAC_TENANT_PASSWORD=J9NL3FLEr=EgYSME
