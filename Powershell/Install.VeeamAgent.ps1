If(!$WebClient) {
  Write-Error "The $WebClient var is empty, meaning the call to GitHub with the token to access the private repo doesn't exist."
  Return
}

## call OS bit check script
($WebClient).DownloadString('https://raw.githubusercontent.com/dkbrookie/PowershellFunctions/master/Function.Get-OSBit.ps1') | iex
$osVer = Get-OSBit

#region checkFiles
$agentLink = "https://support.dkbinnovative.com/labtech/transfer/software/veeam/agent/VeeamAgentWindows_2.2.0.589.exe"
$agentDir = "$env:windir\LTSvc\packages\software\Veeam\Agent"
$agentExe = "$agentDir\VeeamAgentWindows_2.2.0.589.exe"

Try {
  If(!(Test-Path $agentDir)) {
    New-Item -ItemType Directory $agentDir | Out-Null
  }

  If(!(Test-Path $agentExe -PathType Leaf)) {
    ($WebClient).DownloadString('https://raw.githubusercontent.com/dkbrookie/PowershellFunctions/master/Function.Get-OSBit.ps1') | iex
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
#endregion installVeeam
