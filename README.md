[![PowerShell Core Tests](https://github.com/tonysathre/CitrixDownloader/actions/workflows/pester-powershell-core.yaml/badge.svg)](https://github.com/tonysathre/CitrixDownloader/actions/workflows/pester-powershell-core.yaml) [![PowerShell Desktop Tests](https://github.com/tonysathre/CitrixDownloader/actions/workflows/pester-powershell-desktop.yaml/badge.svg)](https://github.com/tonysathre/CitrixDownloader/actions/workflows/pester-powershell-desktop.yaml)

# CitrixDownloader
PowerShell script to automate the download of binaries from Citrix.com.

Supports downloading multiple files at once.

Credit to [Ryan Butler](https://github.com/ryancbutler) for the [original code](https://github.com/ryancbutler/Citrix/blob/master/XenDesktop/AutoDownload/Helpers/Get-CTXBinary.ps1).

## Requirements
* PowerShell 3+ or PowerShell Core 7+
  * Only tested on PowerShell Core 7.2.1 but older versions *probably* work
* Supports Windows, MacOS, and Linux

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

[View Help](./HELP.md)
