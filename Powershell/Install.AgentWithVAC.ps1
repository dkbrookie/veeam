If(!$WebClient) {
  Write-Error "The $WebClient var is empty, meaning the call to GitHub with the token to access the private repo doesn't exist."
  Return
}

## call the Get-InstallApp function to check if these applications are already installed
($WebClient).DownloadString('https://raw.githubusercontent.com/dkbrookie/PowershellFunctions/master/Function.Get-InstalledApp.ps1') | iex
If(!(Get-InstalledApp -AppName 'Veeam Agent for Microsoft Windows')) {
  ## Calls the Veeam Agent installation script
  ($WebClient).DownloadString('https://raw.githubusercontent.com/dkbrookie/veeam/master/Powershell/Install.VeeamAgent.ps1') | iex
}

If(!(Get-InstalledApp -AppName 'Veeam Availability Console Communication Agent')) {
  ## Calls the VAC Agent installation script
  ($WebClient).DownloadString('https://raw.githubusercontent.com/dkbrookie/veeam/master/Powershell/Install.VACAgent.ps1') | iex
}
