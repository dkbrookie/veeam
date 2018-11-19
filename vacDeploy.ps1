#region getOSInfo
Try {
  If((Get-WmiObject win32_operatingsystem | Select-Object -ExpandProperty osarchitecture) -eq '64-bit') {
    $osVer = 'x64'
  } Else {
    $osVer = 'x86'
  }
} Catch {
  Write-Error "Unable to determine OS architecture" | Out-File $logFile -Append
  Return
}
#endregion getOSInfo

#region checkFiles
$agentLink = "https://support.dkbinnovative.com/labtech/transfer/software/veeam/vac/vacagent$osVer.zip"
$dlDir = "$env:windir\LTSvc\packages\veeam\VACAgent"
$VACAgentZip = "$dlDir\VACAgent$osVer.zip"

Try {
  If(!(Test-Path $dlDir)) {
    New-Item -ItemType Directory $dlDir
  }

  If(!(Test-Path $VACAgentZip -PathType Leaf)) {
    Start-BitsTransfer -Source $agentLink -Destination $VACAgentZip
  }
} Catch {
  Write-Error "Failed to download the VAC Agent"
}
#endregion checkFiles


msiexec /i c:\VAC.CommunicationAgent.x64.msi /qn CC_GATEWAY=veeam.dkbinnovative.com VAC_TENANT=DKB VAC_TENANT_PASSWORD=J9NL3FLEr=EgYSME
