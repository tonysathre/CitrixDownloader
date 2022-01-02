BeforeAll {
    $TEMP = [System.IO.Path]::GetTempPath()
    "$TEMP\Citrix_Licensing_11.17.2.0_BUILD_37000.zip", "$TEMP\CitrixProbeAgent2103.msi", "$TEMP\ProfileMgmt_1912.zip" | Remove-Item -Force -ErrorAction SilentlyContinue
}

& .\Get-CTXBinary.ps1 -DLNumber 19997 -OutputFolder $TEMP -CitrixUserName $env:CITRIXUSERNAME -CitrixPassword $env:CITRIXPASSWORD -FileName 'ProfileMgmt_1912.zip' -Name 'Profile Management 1912 LTSR CU4'

Describe 'Downloads a single file from Citrix.com' {
    It 'Downloaded file ProfileMgmt_1912.zip should exist' {
        "$TEMP\ProfileMgmt_1912.zip" | Should -Exist
    }

    It 'ProfileMgmt_1912.zip file hash should match' {
        (Get-FileHash -Path "$TEMP\ProfileMgmt_1912.zip" -Algorithm SHA256).Hash | Should -Be 'EA7885928205AC723D585181EEF87D73F45CC3F7E6CC10BDA0822F9D776D3C75'
    }
}

& .\Get-CTXBinary.ps1 -DLNumber @(9803,19228) -OutputFolder $TEMP -CitrixUserName $env:CITRIXUSERNAME -CitrixPassword $env:CITRIXPASSWORD -FileName @('Citrix_Licensing_11.17.2.0_BUILD_37000.zip','CitrixProbeAgent2103.msi') -Name 'Single-session OS Virtual Delivery Agent 1912 LTSR CU3', 'Workspace Environment Management 2112'

Describe 'Test multi-file download' {
    It 'Downloaded file Citrix_Licensing_11.17.2.0_BUILD_37000.zip should exist' {
        "$TEMP\Citrix_Licensing_11.17.2.0_BUILD_37000.zip" | Should -Exist
    }

    It 'Citrix_Licensing_11.17.2.0_BUILD_37000.zip file hash should match' {
        (Get-FileHash -Path "$TEMP\Citrix_Licensing_11.17.2.0_BUILD_37000.zip" -Algorithm SHA256).Hash | Should -Be '3CA4565CE54D97426B3862F3BEEF120110D60E07BC9030CB5CB130C78A16AA56'
    }

    It 'Downloaded file CitrixProbeAgent2103.msi should exist' {
        "$TEMP\CitrixProbeAgent2103.msi" | Should -Exist
    }

    It 'CitrixProbeAgent2103.msi file hash should match' {
        (Get-FileHash -Path "$TEMP\CitrixProbeAgent2103.msi" -Algorithm SHA256).Hash | Should -Be '69CEDF86A103DD924565FEFE5E0C59F3271333148AAEC2465BA107A9649F912A'
    }
}

AfterAll {
    "$TEMP\Citrix_Licensing_11.17.2.0_BUILD_37000.zip", "$TEMP\CitrixProbeAgent2103.msi", "$TEMP\ProfileMgmt_1912.zip" | Remove-Item -Force   
}