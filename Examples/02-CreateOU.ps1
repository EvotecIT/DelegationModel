
Import-Module .\DelegationModel.psd1 -Force

$Domain = 'ad.evotec.xyz'
$AdministrativeUnit = 'FR_IT_Team06'

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

Start-DelegationModel -Domain $Domain -Definition $OUDefinition -Verbose -LogMaximum 5 -LogFile "$PSScriptRoot\Logs\Delegation_$((Get-Date).ToString('yyyy-MM-dd_HH_mm_ss')).log"