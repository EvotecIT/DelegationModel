
Import-Module .\DelegationModel.psd1 -Force

$AdministrativeUnit = 'FR_IT_Team03'

$OUDefinition = @{
    "Tier2\Accounts01\$AdministrativeUnit"  = @{
        Description                     = "Accounts for Standard users in $AdministrativeUnit"
        ProtectedFromAccidentalDeletion = $true
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

Start-DelegationModel -Domain 'ad.evotec.xyz' -Definition $OUDefinition -Verbose