<#
These vars are set in Automate before the script is called as seen below...

$vccUrl = "@vccURL@"
$tenantID = "@tenantID@"
$tenantPassword ="@tenantPassword@"

Each var is pulled from the %ClientID% for the corresponding Veeam EDFs.
#>

## call OS bit check script

$osVer = [IntPtr]::size
If ($osVer = 8) {
    $osVer = "x64"
} Else {
    $osVer = "x86"
}

#region checkFiles
If ($osVer -eq 'x64') {
    $vacLink = "https://drive.google.com/uc?export=download&id=11wulxXSdJBPcFPQqYt6p63l4-Gx2OBSv"
} Else {
    $vacLink = "https://drive.google.com/uc?export=download&id=11vD9jxOTWIDuEU4zCGqZN2DRTxLBFvW7"
}
$vacDir = "$env:windir\LTSvc\packages\software\veeam\VACAgent"
$VACAgentZip = "$vacDir\VACAgent$osVer.zip"

Try {
  If(!(Test-Path $vacDir)) {
    New-Item -ItemType Directory $vacDir | Out-Null
  }

  If(!(Test-Path $VACAgentZip -PathType Leaf)) {
    (New-Object System.Net.WebClient).DownloadFile($vacLink,$VACAgentZip)
    If(!(Test-Path $VACAgentZip -PathType Leaf)) {
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
Add-Type -assembly "system.io.compression.filesystem"
[io.compression.zipfile]::ExtractToDirectory("$VACAgentZip", "$vacDir")

## Install VAC Agent
Start-Process msiexec.exe -Wait -ArgumentList "/i ""$vacDir\VACAgent$osVer\VAC.CommunicationAgent.$osVer.msi"" /qn CC_GATEWAY=$vccUrl VAC_TENANT=$tenantID VAC_TENANT_PASSWORD=$tenantPassword"
#endregion installVAC

## Once the install is complete with the client creds, the service needs to be restarted to connect to the DKB VCC server
Start-Sleep -s 30
Stop-Service -Name VeeamManagementAgentSvc -Force
Start-Service -Name VeeamManagementAgentSvc
Write-Host "VAC Agent installation complete"
