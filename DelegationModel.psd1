@{
    AliasesToExport      = @()
    Author               = 'Przemyslaw Klys'
    CmdletsToExport      = @()
    CompanyName          = 'Evotec'
    CompatiblePSEditions = @('Desktop')
    Copyright            = '(c) 2011 - 2023 Przemyslaw Klys @ Evotec. All rights reserved.'
    Description          = 'DelegationModel is a PowerShell module to create and manage delegation model'
    FunctionsToExport    = @('Start-DelegationGroups', 'Start-DelegationModel')
    GUID                 = '25a17911-7a7a-4c86-8543-aefb907874f7'
    ModuleVersion        = '0.0.3'
    PowerShellVersion    = '5.1'
    PrivateData          = @{
        PSData = @{
            Tags                       = @('Windows')
            ProjectUri                 = 'https://github.com/EvotecIT/DelegationModel'
            ExternalModuleDependencies = @('ActiveDirectory')
        }
    }
    RequiredModules      = @(@{
            ModuleVersion = '0.0.180'
            ModuleName    = 'PSWriteHTML'
            Guid          = 'a7bdf640-f5cb-4acf-9de0-365b322d245c'
        }, @{
            ModuleVersion = '0.0.149'
            ModuleName    = 'ADEssentials'
            Guid          = '9fc9fd61-7f11-4f4b-a527-084086f1905f'
        }, 'ActiveDirectory')
    RootModule           = 'DelegationModel.psm1'
}