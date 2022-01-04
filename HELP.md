## Help
```

NAME
    Get-CTXBinary.ps1
    
SYNOPSIS
    Downloads a binary from Citrix.com
    
    
SYNTAX
    Get-CTXBinary.ps1 -DLNumber <Int32[]> -FileName <String[]> -Name <String[]> -OutputFolder <String> -CitrixUserName <String> -CitrixPassword <String> [-Proxy <Uri>] [-ProxyUseDefaultCredentials] [<CommonParameters>]
    
    Get-CTXBinary.ps1 -DLNumber <Int32[]> -FileName <String[]> -Name <String[]> -OutputFolder <String> -CitrixUserName <String> -CitrixPassword <String> [-Proxy <Uri>] [-ProxyCredential <PSCredential>] [<CommonParameters>]
    
    
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
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216). 
    
INPUTS
    
OUTPUTS
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS > Get-CTXBinary -DLNumber 19427 -CitrixUserName mycitrixusername -CitrixPassword mycitrixpassword -OutputFolder C:\temp
    
    
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS > Get-CTXBinary -DLNumber 19427 -CitrixUserName mycitrixusername -CitrixPassword mycitrixpassword -OutputFolder C:\temp -Proxy http://proxy.domain.com:8080 -ProxyUseDefaultCredentials
    
    
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS > $ProxyCredential = Get-Credential Domain\UserName
    Get-CTXBinary -DLNumber 19427 -CitrixUserName mycitrixusername -CitrixPassword mycitrixpassword -OutputFolder C:\temp -Proxy http://proxy.domain.com:8080 -ProxyCredential $ProxyCredential
    
    
    
    
    
    
    -------------------------- EXAMPLE 4 --------------------------
    
    PS > Get-CTXBinary.ps1 -DLNumber @(19427,20209) -OutputFolder C:\temp -CitrixUserName mycitrixusername -CitrixPassword $CitrixPassword -FileName @('VDAWorkstationSetup_1912.exe','Workspace-Environment-Management-v-2112-01-00-01.zip') -Name @('Single-session OS Virtual Delivery Agent 1912 LTSR CU3', 'Workspace Environment Management 2112')
    
    Download multiple files at once
    
    
    
    
    
RELATED LINKS
    https://github.com/tonysathre/CitrixDownloader


```
