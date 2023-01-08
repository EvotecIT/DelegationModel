@{
    AliasesToExport      = 'New-DelegationOU'
    Author               = 'Przemyslaw Klys'
    CmdletsToExport      = @()
    CompanyName          = 'Evotec'
    CompatiblePSEditions = @('Desktop', 'Core')
    Copyright            = '(c) 2011 - 2023 Przemyslaw Klys @ Evotec. All rights reserved.'
    Description          = 'DelegationModel is a PowerShell module to create and manage delegation model'
    FunctionsToExport    = @('New-DelegationGroup', 'New-DelegationOrganizationalUnit', 'Start-DelegationGroups', 'Start-DelegationModel')
    GUID                 = '25a17911-7a7a-4c86-8543-aefb907874f7'
    ModuleVersion        = '0.0.3'
    PowerShellVersion    = '5.1'
    PrivateData          = @{
        PSData = @{
            Tags                       = @('Windows')
            ProjectUri                 = 'https://github.com/EvotecIT/DelegationModel'
            IconUri                    = 'https://evotec.xyz/wp-content/uploads/2023/01/DelegationModel.png'
            ExternalModuleDependencies = @('ActiveDirectory')
        }
    }
    RequiredModules      = @(@{
            ModuleVersion = '0.0.255'
            ModuleName    = 'PSSharedGoods'
            Guid          = 'ee272aa8-baaa-4edf-9f45-b6d6f7d844fe'
        }, @{
            ModuleVersion = '0.87.3'
            ModuleName    = 'PSWriteColor'
            Guid          = '0b0ba5c5-ec85-4c2b-a718-874e55a8bc3f'
        }, @{
            ModuleVersion = '0.0.180'
            ModuleName    = 'PSWriteHTML'
            Guid          = 'a7bdf640-f5cb-4acf-9de0-365b322d245c'
        }, @{
            ModuleVersion = '0.0.150'
            ModuleName    = 'ADEssentials'
            Guid          = '9fc9fd61-7f11-4f4b-a527-084086f1905f'
        }, 'ActiveDirectory')
    RootModule           = 'DelegationModel.psm1'
}