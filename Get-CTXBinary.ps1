# Credit to Ryan Butler
<#
.SYNOPSIS
  Downloads a Citrix VDA installer or ISO from Citrix.com utilizing authentication
.DESCRIPTION
  Downloads a Citrix VDA installer or ISO from Citrix.com utilizing authentication
.PARAMETER DLNumber
  Number assigned to binary (see Downloads.csv)
.PARAMETER OutputFolder
  Path to store Downloaded file (C:\temp)
.PARAMETER CitrixUserName
  Citrix.com username
.PARAMETER CitrixPassword
  Citrix.com password
.EXAMPLE
  Get-CTXBinary -DLNumber 19427 -DLExe -CitrixUserName mycitrixusername -CitrixPassword mycitrixpassword -OutputFolder C:\temp
#>

Param(
	[Parameter(Mandatory)]$DLNumber,
	[Parameter(Mandatory)]$OutputFolder,
	[Parameter(Mandatory)]$CitrixUserName,
	[Parameter(Mandatory)]$CitrixPassword
)

$ProgressPreference = 'SilentlyContinue'

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

$Csv = Import-Csv (Join-Path $PSScriptRoot Downloads.csv) -ErrorAction Stop  
$DLExe = ($Csv | Where-Object DLNumber -eq $DLNumber).Filename
$DLName = ($Csv | Where-Object DLNumber -eq $DLNumber).Name
$DownloadUrl = "https://secureportal.citrix.com/Licensing/Downloads/UnrestrictedDL.aspx?DLID=${DLNumber}&URL=https://Downloads.citrix.com/${DLNumber}/${DLExe}"
$Download = Invoke-WebRequest -Uri $DownloadUrl -WebSession $WebSession -UseBasicParsing -Method GET
$OutFile = Join-Path $OutputFolder $DLExe
$WebForm = @{ 
	"chkAccept"            = "on"
	"clbAccept"            = "Accept"
	"__VIEWSTATEGENERATOR" = ($Download.InputFields | Where-Object { $_.id -eq "__VIEWSTATEGENERATOR" }).value
	"__VIEWSTATE"          = ($Download.InputFields | Where-Object { $_.id -eq "__VIEWSTATE" }).value
	"__EVENTVALIDATION"    = ($Download.InputFields | Where-Object { $_.id -eq "__EVENTVALIDATION" }).value
}

#Download
"Downloading {0} to {1}" -f $DLName, $OutFile
try {
	Invoke-WebRequest -Uri $DownloadUrl -WebSession $WebSession -Method POST -Body $WebForm -ContentType "application/x-www-form-urlencoded" -UseBasicParsing -OutFile $OutFile
	"Download completed successfully"
} catch {
	throw $_
}