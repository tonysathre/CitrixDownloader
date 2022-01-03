$global:TEMP = [System.IO.Path]::GetTempPath()
$TEMP = $TEMP.Substring(0, $TEMP.Length-1)
[securestring]$secStringPassword = ConvertTo-SecureString $env:PROXY_PASSWORD -AsPlainText -Force
[pscredential]$global:ProxyCredential = New-Object System.Management.Automation.PSCredential ($env:PROXY_USER, $secStringPassword)

$Params = @{
    DLNumber       = 19997
    OutputFolder   = $TEMP
    CitrixUserName = $env:CITRIXUSERNAME
    CitrixPassword = $env:CITRIXPASSWORD
    FileName       = 'ProfileMgmt_1912.zip'
    Name           = 'Profile Management 1912 LTSR CU4'
}

& ./Get-CTXBinary.ps1 @Params

Describe 'Downloads a single file from Citrix.com' {
    It 'Downloaded file ProfileMgmt_1912.zip should exist' {
        "$TEMP/ProfileMgmt_1912.zip" | Should -Exist
    }

    It 'ProfileMgmt_1912.zip file hash should match' {
        (Get-FileHash -Path "$TEMP/ProfileMgmt_1912.zip" -Algorithm SHA256).Hash | Should -Be 'EA7885928205AC723D585181EEF87D73F45CC3F7E6CC10BDA0822F9D776D3C75'
    }
}

$Params = @{
    DLNumber       = @(9803,19228)
    OutputFolder   = $TEMP
    CitrixUserName = $env:CITRIX_USERNAME
    CitrixPassword = $env:CITRIX_PASSWORD
    FileName       = @('Citrix_Licensing_11.17.2.0_BUILD_37000.zip','CitrixProbeAgent2103.msi')
    Name           = @('Single-session OS Virtual Delivery Agent 1912 LTSR CU3', 'Workspace Environment Management 2112')
}

& ./Get-CTXBinary.ps1 @Params

Describe 'Test multi-file download' {
    It 'Downloaded file Citrix_Licensing_11.17.2.0_BUILD_37000.zip should exist' {
        "$TEMP/Citrix_Licensing_11.17.2.0_BUILD_37000.zip" | Should -Exist
    }

    It 'Citrix_Licensing_11.17.2.0_BUILD_37000.zip file hash should match' {
        (Get-FileHash -Path "$TEMP/Citrix_Licensing_11.17.2.0_BUILD_37000.zip" -Algorithm SHA256).Hash | Should -Be '3CA4565CE54D97426B3862F3BEEF120110D60E07BC9030CB5CB130C78A16AA56'
    }

    It 'Downloaded file CitrixProbeAgent2103.msi should exist' {
        "$TEMP/CitrixProbeAgent2103.msi" | Should -Exist
    }

    It 'CitrixProbeAgent2103.msi file hash should match' {
        (Get-FileHash -Path "$TEMP/CitrixProbeAgent2103.msi" -Algorithm SHA256).Hash | Should -Be '69CEDF86A103DD924565FEFE5E0C59F3271333148AAEC2465BA107A9649F912A'
    }
}

$Params = @{
    DLNumber        = 19430
    OutputFolder    = $TEMP
    CitrixUserName  = $env:CITRIX_USERNAME
    CitrixPassword  = $env:CITRIX_PASSWORD
    FileName        = 'CitrixStoreFront-x64.exe'
    Name            = 'StoreFront 1912 LTSR CU3'
    Proxy           = 'http://localhost:3128'
    ProxyCredential = $ProxyCredential

}

& ./Get-CTXBinary.ps1 @Params

Describe 'Downloads a single file from Citrix.com using proxy' {
    It 'Downloaded file CitrixStoreFront-x64.exe should exist' {
        "$TEMP/CitrixStoreFront-x64.exe" | Should -Exist
    }

    It 'CitrixStoreFront-x64.exe file hash should match' {
        (Get-FileHash -Path "$TEMP/CitrixStoreFront-x64.exe" -Algorithm SHA256).Hash | Should -Be '100346fd79ed3854e81125e87ccece19d5189f95a6b11da61e0f33cf59c4fb46'
    }
}

$Params = @{
    DLNumber        = @(12509,12509)
    OutputFolder    = $TEMP
    CitrixUserName  = $env:CITRIX_USERNAME
    CitrixPassword  = $env:CITRIX_PASSWORD
    FileName        = @('xendesktopvda_21.12.0.30-1.ubuntu16.04_amd64.deb','xendesktopvda_21.12.0.30-1.ubuntu18.04_amd64.deb')
    Name            = @('Linux Virtual Delivery Agent 2112 (Ubuntu 16.04)', 'Linux Virtual Delivery Agent 2112 (Ubuntu 18.04)')
    Proxy           = 'http://localhost:3128'
    ProxyCredential = $ProxyCredential
}

& ./Get-CTXBinary.ps1 @Params

Describe 'Test multi-file download using proxy' {
    It 'Downloaded file xendesktopvda_21.12.0.30-1.ubuntu16.04_amd64.deb should exist' {
        "$TEMP/xendesktopvda_21.12.0.30-1.ubuntu16.04_amd64.deb" | Should -Exist
    }

    It 'Citrix_Licensing_11.17.2.0_BUILD_37000.zip file hash should match' {
        (Get-FileHash -Path "$TEMP/xendesktopvda_21.12.0.30-1.ubuntu16.04_amd64.deb" -Algorithm SHA256).Hash | Should -Be 'E20861E38AC698D3FAC5EA895F77D22FDFF31B2A14C11159FE5D4B9730A01AD8'
    }

    It 'Downloaded file xendesktopvda_21.12.0.30-1.ubuntu18.04_amd64.deb should exist' {
        "$TEMP/xendesktopvda_21.12.0.30-1.ubuntu18.04_amd64.deb" | Should -Exist
    }

    It 'xendesktopvda_21.12.0.30-1.ubuntu18.04_amd64.deb file hash should match' {
        (Get-FileHash -Path "$TEMP/xendesktopvda_21.12.0.30-1.ubuntu18.04_amd64.deb" -Algorithm SHA256).Hash | Should -Be '8402D6B0AA0F7CD9196BD6D158B19826DBBE97BAF2EC84D798E6EC9106DEAB2A'
    }
}