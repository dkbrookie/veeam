$vccUrl = "veeam.dkbinnovative.com"
$tenantID =
$tenantPassword =


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
$vacLink = "https://support.dkbinnovative.com/labtech/transfer/software/veeam/vac/vacagent$osVer.zip"
$vacDir = "$env:windir\LTSvc\packages\software\veeam\VACAgent"
$VACAgentZip = "$vacDir\VACAgent$osVer.zip"
$7zipDir = "$env:windir\LTSvc\packages\software\7zip"
$7zipURL = "https://support.dkbinnovative.com/labtech/Transfer/software/7zip/7za.exe"
$7zipExe = "$7zipDir\7zip.exe"

Try {
  If(!(Test-Path $vacDir)) {
    New-Item -ItemType Directory $vacDir | Out-Null
  }

  If(!(Test-Path $VACAgentZip -PathType Leaf)) {
    Start-BitsTransfer -Source $vacLink -Destination $VACAgentZip
    If(!(Test-Path $VACAgentZip -PathType Leaf)) {
      Write-Error "Failed to download VACAgent zip"
      Break
    }
  }
  If(!(Test-Path $7zipDir)) {
    New-Item -ItemType Directory $7zipDir | Out-Null
  }
  If(!(Test-Path $7zipExe -PathType Leaf)) {
    Start-BitsTransfer -Source $7zipURL -Destination $7zipExe
    If(!(Test-Path $7zipExe -PathType Leaf)) {
      Write-Error "Failed to download VACAgent zip"
      Break
    }
  }
} Catch {
  Write-Error "Failed to download the VAC Agent"
}
#endregion checkFiles

#region installVAC
msiexec /i "$vacDir\VAC.CommunicationAgent.x64.msi" /qn CC_GATEWAY=$vccUrl VAC_TENANT=$tenantID VAC_TENANT_PASSWORD=$tenantPassword
#endregion installVAC
