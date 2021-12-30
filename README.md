# CitrixDownloader

## Updating [Downloads.csv](Downloads.csv)
1. Login to your Citrix.com account.
2. Browse to the [Citrix Downloads](https://www.citrix.com/downloads/) page and find the download page for the file you'd like to add.
3. Right-click the `Download File` button and choose Inspect. This will open the page in the browser DevTools.
   * Inspect might be called something else in other browsers. Inspect is what it's called in Edge and Chrome.
   * Alternatively you can just download the file and get the info from the Downloads page in your browser.
4. The DLNumber will be after `http://downloads.citrix.com/` in the hyperlink. Should be a 5 digit number such as `20116`.
5. The FileName will be after the DLNumber in the URL. For example the following is what to look for in the DevTools. This is for `Multi-session OS Virtual Delivery Agent 2112` VDA.
   
```html
<a href="javascript:void(0);" data-secureportal="true" class="ctx-dl-link ctx-photo" rel="https://secureportal.citrix.com/udl.asp?DLID=20116&amp;URL=https://downloads.citrix.com/20116/VDAServerSetup_2112.exe" id="downloadcomponent">
            <span class="icon-box-download"></span><span>Download File</span>
</a>
```

6. Add a row to [Downloads.csv](Downloads.csv) with the DLNumber and FileName from the Citrix download URL. The Name column is arbitrary and can be anything, but I'd recommend using what Citrix calls them for clarity.
