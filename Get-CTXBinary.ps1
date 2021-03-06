# Credit to Ryan Butler for the original code
# https://github.com/ryancbutler/Citrix/blob/master/XenDesktop/AutoDownload/Helpers/Get-CTXBinary.ps1

<#
.SYNOPSIS
  Downloads a binary from Citrix.com
.DESCRIPTION
  Downloads a binary from Citrix.com
.PARAMETER DLNumber
  ID assigned to binary by Citrix (see Downloads.csv for examples)
.PARAMETER OutputFolder
  Path to store downloaded file (C:\temp)
.PARAMETER CitrixUserName
  Citrix.com username
.PARAMETER CitrixPassword
  Citrix.com password
.PARAMETER Proxy
  Specifies a proxy server for the request, rather than connecting directly to the Internet resource. Enter the URI of a network proxy server.
.PARAMETER ProxyCredentials
  Specifies a user account that has permission to use the proxy server that is specified by the Proxy parameter. The default is the current user.
.PARAMETER ProxyUseDefaultCredentials
  Indicates that the script uses the credentials of the current user to access the proxy server that is specified by the Proxy parameter.
.EXAMPLE
  Get-CTXBinary -DLNumber 19427 -CitrixUserName mycitrixusername -CitrixPassword mycitrixpassword -OutputFolder C:\temp
.EXAMPLE
  Get-CTXBinary -DLNumber 19427 -CitrixUserName mycitrixusername -CitrixPassword mycitrixpassword -OutputFolder C:\temp -Proxy http://proxy.domain.com:8080 -ProxyUseDefaultCredentials
.EXAMPLE
  $ProxyCredential = Get-Credential Domain\UserName
  Get-CTXBinary -DLNumber 19427 -CitrixUserName mycitrixusername -CitrixPassword mycitrixpassword -OutputFolder C:\temp -Proxy http://proxy.domain.com:8080 -ProxyCredential $ProxyCredential
.EXAMPLE
  Get-CTXBinary -DLNumber @(19427,20209) -OutputFolder C:\temp -CitrixUserName mycitrixusername -CitrixPassword $CitrixPassword -FileName @('VDAWorkstationSetup_1912.exe','Workspace-Environment-Management-v-2112-01-00-01.zip') -Name @('Single-session OS Virtual Delivery Agent 1912 LTSR CU3', 'Workspace Environment Management 2112')
  
  Download multiple files at once
.LINK
  https://github.com/tonysathre/CitrixDownloader
#>

[CmdletBinding(DefaultParameterSetName = 'ProxyUseDefaultCredentials')]
Param(
	[Parameter(Mandatory)]
	[int[]]$DLNumber,

	[Parameter(Mandatory)]
	[string[]]$FileName,

	[Parameter(Mandatory)]
	[string[]]$Name,

	[Parameter(Mandatory)]
	[string]$OutputFolder,

	[Parameter(Mandatory)]
	[string]$CitrixUserName,

	[Parameter(Mandatory)]
	[string]$CitrixPassword,

	[Parameter(Mandatory = $false)]
	[uri]$Proxy,

	[Parameter(Mandatory = $false, ParameterSetName = 'ProxyCredential')]
	[pscredential]$ProxyCredential,

	[Parameter(Mandatory = $false, ParameterSetName = 'ProxyUseDefaultCredentials')]
	[switch]$ProxyUseDefaultCredentials
)

BEGIN {
	[Net.ServicePointManager]::SecurityProtocol = "Tls12, Tls13"
	$ProgressPreference = 'SilentlyContinue'

	if ($PSBoundParameters.ContainsKey('Proxy')) {
		$PSDefaultParameterValues = @{
			"Invoke-WebRequest:Proxy" = $Proxy
		}
	}
	
	if ($PSBoundParameters.ContainsKey('ProxyCredential')) {
		$PSDefaultParameterValues.Add(
			"Invoke-WebRequest:ProxyCredential", $ProxyCredential
		)
	}
	
	if ($PSBoundParameters.ContainsKey('ProxyUseDefaultCredentials')) {
		$PSDefaultParameterValues.Add(
			"Invoke-WebRequest:ProxyUseDefaultCredentials", $ProxyUseDefaultCredentials
		)
	}

	$Downloads = New-Object System.Collections.ArrayList
	# Create array of pscustomobjects so we can iterate over them
	for ($i -eq 0; $i -lt $DLNumber.Length; $i++) {
		$Downloads.Add([pscustomobject][ordered]@{
			'DLNumber' = $DLNumber[$i - 1]
			'FileName' = $FileName[$i - 1]
			'Name'     = $Name[$i - 1]
		}) | Out-Null
	}

	#Initialize Session
	Invoke-WebRequest "https://identity.citrix.com/Utility/STS/Sign-In?ReturnUrl=%2fUtility%2fSTS%2fsaml20%2fpost-binding-response" -SessionVariable WebSession -UseBasicParsing | Out-Null

	#Set Form
	$Form = @{
		"persistent" = "on"
		"userName"   = $CitrixUserName
		"password"   = $CitrixPassword
	}

	#Authenticate
	try {
		Invoke-WebRequest -Uri ("https://identity.citrix.com/Utility/STS/Sign-In?ReturnUrl=%2fUtility%2fSTS%2fsaml20%2fpost-binding-response") -WebSession $WebSession -Method POST -Body $Form -ContentType "application/x-www-form-urlencoded" -UseBasicParsing -ErrorAction Stop | Out-Null
	}
	catch {
		if ($_.Exception.Response.StatusCode.Value__ -eq 500) {
			Write-Verbose "500 returned on auth. Ignoring"
			Write-Verbose $_.Exception.Response
			Write-Verbose $_.Exception.Message
		}
		else {
			throw $_
		}
	}
}

PROCESS {
	foreach ($DL in $Downloads.GetEnumerator()) {
		$DownloadUrl = "https://secureportal.citrix.com/Licensing/Downloads/UnrestrictedDL.aspx?DLID=$(($DL.DLNumber))&URL=https://downloads.citrix.com/$(($DL.DLNumber))/$(($DL.FileName))"
		$Download    = Invoke-WebRequest -Uri $DownloadUrl -WebSession $WebSession -UseBasicParsing -Method GET
		$OutFile     = Join-Path $OutputFolder $DL.FileName

		$WebForm = @{
			"chkAccept"            = "on"
			"clbAccept"            = "Accept"
			"__VIEWSTATEGENERATOR" = ($Download.InputFields | Where-Object { $_.id -eq "__VIEWSTATEGENERATOR" }).value
			"__VIEWSTATE"          = ($Download.InputFields | Where-Object { $_.id -eq "__VIEWSTATE" }).value
			"__EVENTVALIDATION"    = ($Download.InputFields | Where-Object { $_.id -eq "__EVENTVALIDATION" }).value
		}

		#Download
		"Downloading '{0}' to {1}" -f $DL.Name, $OutFile
		try {
			Invoke-WebRequest -Uri $DownloadUrl -WebSession $WebSession -Method POST -Body $WebForm -ContentType "application/x-www-form-urlencoded" -UseBasicParsing -OutFile $OutFile
			"Download completed successfully"
		} catch {
			throw $_
		}
	}
}

END {}
