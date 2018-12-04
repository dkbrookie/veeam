<#
These URLs are set in Automate before the script is called as seen below...

$vccUrl = "@vccURL@"
$tenantID = "@tenantID@"
$tenantPassword ="@tenantPassword@"

Each var is pulled from the %ClientID% for the corresponding Veeam EDFs.
#>

## call OS bit check script
If(!$WebClient) {
  Write-Error "The $WebClient var is empty, meaning the call to GitHub with the token to access the private repo doesn't exist."
  Return
} Else {
  ($WebClient).DownloadString('https://raw.githubusercontent.com/dkbrookie/PowershellFunctions/master/Function.Get-OSBit.ps1') | iex
  $osVer = Get-OSBit
}

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
  Write-Error "Failed to download all required files"
}
#endregion checkFiles


#region installVAC
## Unzip the downloaded VAC zip
Start-Process $7zipExe -Wait -ArgumentList "x $vacAgentZip -o""$vacDir"" -y"
## Install VAC Agent
Start-Process msiexec.exe -Wait -ArgumentList "/i ""$vacDir\VACAgent$osVer\VAC.CommunicationAgent.x64.msi"" /qn CC_GATEWAY=$vccUrl VAC_TENANT=$tenantID ""VAC_TENANT_PASSWORD=$tenantPassword"""
#endregion installVAC
