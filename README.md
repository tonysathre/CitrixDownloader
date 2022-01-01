# CitrixDownloader
PowerShell script to automate the download of binaries from Citrix.com.

Supports downloading multiple files at once.

Credit to [Ryan Butler](https://github.com/ryancbutler) for the [original code](https://github.com/ryancbutler/Citrix/blob/master/XenDesktop/AutoDownload/Helpers/Get-CTXBinary.ps1).

## Requirements
* PowerShell 3+ or PowerShell Core 7+
  * Only tested on PowerShell Core 7.2.1 but older versions may work
* Windows or Linux
  * MacOS probably works but I don't have a Mac to test it

## Getting DLNumber and FileName

The [Downloads.csv](Downloads.csv) file is just for reference and is not required by the script.

1. Login to your Citrix.com account.
2. Browse to the [Citrix Downloads](https://www.citrix.com/downloads/) page and find the download page for the file you'd like to download.
3. Right-click the `Download File` button and choose Inspect. This will open the page in the browser DevTools.
   * Inspect might be called something else in other browsers. Inspect is what it's called in Edge and Chrome.
   * Alternatively you can just download the file and get the URL from the Downloads page in your browser. This is probably easier.
4. The DLNumber will be after `http://downloads.citrix.com/` in the hyperlink. Should be a 5 digit number such as `20116`.
5. The FileName will be after the DLNumber in the URL. For example the following is what to look for in the DevTools. This is for `Multi-session OS Virtual Delivery Agent 2112` VDA.
   
```html
<a href="javascript:void(0);" data-secureportal="true" class="ctx-dl-link ctx-photo" rel="https://secureportal.citrix.com/udl.asp?DLID=20116&amp;URL=https://downloads.citrix.com/20116/VDAServerSetup_2112.exe" id="downloadcomponent">
            <span class="icon-box-download"></span><span>Download File</span>
</a>
```

## Help
```
NAME
    C:\Users\Tony\git\CitrixDownloader\Get-CTXBinary.ps1
    
SYNOPSIS
    Downloads a binary from Citrix.com
    
    
SYNTAX
    Get-CTXBinary.ps1 -DLNumber <Int32[]> -FileName <String[]> -Name <String[]> -OutputFolder <String> -CitrixUserName <String> -CitrixPassword <String> [-Proxy <Uri>] 
    [-ProxyUseDefaultCredentials] [<CommonParameters>]
    
    Get-CTXBinary.ps1 -DLNumber <Int32[]> -FileName <String[]> -Name <String[]> -OutputFolder <String> -CitrixUserName <String> -CitrixPassword <String> [-Proxy <Uri>] 
    [-ProxyCredential <PSCredential>] [<CommonParameters>]
    
    
DESCRIPTION
    Downloads a binary from Citrix.com
    

PARAMETERS
    -DLNumber <Int32[]>
        ID assigned to binary by Citrix (see Downloads.csv for examples)
        
        Required?                    true
        Position?                    named
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -FileName <String[]>
        
        Required?                    true
        Position?                    named
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -Name <String[]>
        
        Required?                    true
        Position?                    named
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -OutputFolder <String>
        Path to store downloaded file (C:\temp)
        
        Required?                    true
        Position?                    named
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -CitrixUserName <String>
        Citrix.com username
        
        Required?                    true
        Position?                    named
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -CitrixPassword <String>
        Citrix.com password
        
        Required?                    true
        Position?                    named
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -Proxy <Uri>
        Specifies a proxy server for the request, rather than connecting directly to the Internet resource. Enter the URI of a network proxy server.
        
        Required?                    false
        Position?                    named
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -ProxyCredential <PSCredential>
        
        Required?                    false
        Position?                    named
        Default value                
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    -ProxyUseDefaultCredentials [<SwitchParameter>]
        Indicates that the script uses the credentials of the current user to access the proxy server that is specified by the Proxy parameter.
        
        Required?                    false
        Position?                    named
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216). 
    
INPUTS
    
OUTPUTS
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-CTXBinary -DLNumber 19427 -CitrixUserName mycitrixusername -CitrixPassword mycitrixpassword -OutputFolder C:\temp
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>Get-CTXBinary -DLNumber 19427 -CitrixUserName mycitrixusername -CitrixPassword mycitrixpassword -OutputFolder C:\temp -Proxy http://proxy.domain.com:8080 -ProxyUseDefaultCredentials
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS C:\>$ProxyCredential = Get-Credential Domain\UserName
    
    Get-CTXBinary -DLNumber 19427 -CitrixUserName mycitrixusername -CitrixPassword mycitrixpassword -OutputFolder C:\temp -Proxy http://proxy.domain.com:8080 -ProxyCredential $ProxyCredential
    
    
    -------------------------- EXAMPLE 4 --------------------------
    
    PS C:\>Get-CTXBinary.ps1 -DLNumber @(19427,20209) -OutputFolder C:\temp -CitrixUserName asathre688 -CitrixPassword $CitrixPassword -FileName 
    @('VDAWorkstationSetup_1912.exe','Workspace-Environment-Management-v-2112-01-00-01.zip') -Name @('Single-session OS Virtual Delivery Agent 1912 LTSR CU3', 'Workspace Environment Management 2112')
    
    Download multiple files at once
```
