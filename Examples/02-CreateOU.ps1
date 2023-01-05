
Import-Module .\DelegationModel.psd1 -Force

$Domain = 'ad.evotec.xyz'
$AdministrativeUnit = 'FR_IT_Team06'

$Global = @{
    Domain                          = $Domain
    AdministrativeUnit              = $AdministrativeUnit
    #Description                     = "Accounts for users in $AdministrativeUnit"
    ProtectedFromAccidentalDeletion = $true
}

$OUDefinition = @{
    "Tier2\Accounts01\$AdministrativeUnit"  = @{
        Description                     = "Accounts for users in $AdministrativeUnit"
        ProtectedFromAccidentalDeletion = $false
    }
    "Tier2\Accounts02\$AdministrativeUnit"  = @{
        Description                     = "Accounts for Vip users in $AdministrativeUnit"
        ProtectedFromAccidentalDeletion = $true
    }
    "Tier2\Devices01\$AdministrativeUnit"   = @{

    }
    "Tier2\Groups01\$AdministrativeUnit"    = @{

    }
    "Tier2\Instruments\$AdministrativeUnit" = @{

    }
    "Tier2\Resources\$AdministrativeUnit"   = @{

    }
}

Start-DelegationModel -Domain $Domain -Definition $OUDefinition -Verbose