If(!$WebClient) {
  Write-Error "The $WebClient var is empty, meaning the call to GitHub with the token to access the private repo doesn't exist."
  Return
}

## Delete the reboot pending reg key if it exists so Veeam can successfully install
$rebootKey = Test-Path "HKLM:\SOFTWARE\Microsoft\WIndows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired"
If($rebootKey) {
  Remove-Item $rebootKey
  Write-Host "Note there was a reboot pending, but the script auto deleted the reboot pending key to attempt to install Veeam Agent without a reboot. If the install still fails, reboot the machine before retrying."
}

#region checkFiles
$agentLink = "https://support.dkbinnovative.com/labtech/transfer/software/veeam/agent/VeeamAgentWindows_3.0.2.1170.exe"
$agentDir = "$env:windir\LTSvc\packages\software\Veeam\Agent"
$agentExe = "$agentDir\VeeamAgentWindows_2.2.0.589.exe"

Try {
  If(!(Test-Path $agentDir)) {
    New-Item -ItemType Directory $agentDir | Out-Null
  }

  If(!(Test-Path $agentExe -PathType Leaf)) {
    (New-Object System.Net.WebClient).DownloadFile($agentLink,$agentExe)
    If(!(Test-Path $agentExe -PathType Leaf)) {
      Write-Error "Failed to download $agentExe"
      Break
    }
  }
} Catch {
  Write-Error "Failed to download all required files"
}
#endregion checkFiles


#region installVeeam
## Install VAC Agent
Start-Process $agentExe -Wait -ArgumentList "/silent /accepteula /acceptthirdpartylicenses"
Write-Host "Veeam Agent installation complete"
#endregion installVeeam
