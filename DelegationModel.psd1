@{
    AliasesToExport      = @()
    Author               = 'Przemyslaw Klys'
    CmdletsToExport      = @()
    CompanyName          = 'Evotec'
    CompatiblePSEditions = @('Desktop')
    Copyright            = '(c) 2011 - 2022 Przemyslaw Klys @ Evotec. All rights reserved.'
    Description          = 'DelegationModel is a PowerShell module to create and manage delegation model'
    FunctionsToExport    = @('Start-DelegationGroups', 'Start-DelegationModel')
    GUID                 = '25a17911-7a7a-4c86-8543-aefb907874f7'
    ModuleVersion        = '0.0.1'
    PowerShellVersion    = '5.1'
    PrivateData          = @{
        PSData = @{
            Tags                       = @('Windows')
            ExternalModuleDependencies = @('ActiveDirectory')
        }
    }
    RequiredModules      = @(@{
            ModuleVersion = '0.9.1'
            ModuleName    = 'Mailozaurr'
            Guid          = '2b0ea9f1-3ff1-4300-b939-106d5da608fa'
        }, @{
            ModuleVersion = '0.0.180'
            ModuleName    = 'PSWriteHTML'
            Guid          = 'a7bdf640-f5cb-4acf-9de0-365b322d245c'
        }, 'ActiveDirectory')
    RootModule           = 'DelegationModel.psm1'
}