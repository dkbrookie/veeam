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

## Call OS bit check script
($WebClient).DownloadString('https://raw.githubusercontent.com/dkbrookie/PowershellFunctions/master/Function.Get-OSBit.ps1') | iex
$osVer = Get-OSBit

#region checkFiles
$agentLink = "https://drive.google.com/uc?export=download&id=12Cu9ZG5iEl9_Iaqod6vaj2wQj1HvS3cK"
$agentDir = "$env:windir\LTSvc\packages\software\Veeam\Agent"
$agentExe = "$agentDir\VeeamAgentWindows_2.2.0.589.exe"

Try {
  If(!(Test-Path $agentDir)) {
    New-Item -ItemType Directory $agentDir | Out-Null
  }

  If(!(Test-Path $agentExe -PathType Leaf)) {
    ($WebClient).DownloadString('https://raw.githubusercontent.com/dkbrookie/PowershellFunctions/master/Function.Get-FileDownload.ps1') | iex
    Get-FileDownload -FileURL $agentLink -DestinationFile $agentExe
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
Start-Process $agentExe -Wait -ArgumentList "/silent /accepteula"
Write-Host "Veeam Agent installation complete"
#endregion installVeeam
