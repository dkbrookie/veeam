If(!$WebClient) {
  Write-Error "The $WebClient var is empty, meaning the call to GitHub with the token to access the private repo doesn't exist. Exiting script."
  Return
}

$veeamAgent = "Veeam Agent for Microsoft Windows"
$vacAgent = "Veeam Availability Console Communication Agent"

## Calls the Veeam Agent installation script
($WebClient).DownloadString('https://raw.githubusercontent.com/dkbrookie/veeam/master/Powershell/Install.VeeamAgent.ps1') | iex

## Calls the VAC Agent installation script
($WebClient).DownloadString('https://raw.githubusercontent.com/dkbrookie/veeam/master/Powershell/Install.VACAgent.ps1') | iex
