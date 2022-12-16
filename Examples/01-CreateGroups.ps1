
Import-Module .\DelegationModel.psd1 -Force

$Destination = 'OU=Delegation,OU=Groups,OU=Production,DC=ad,DC=evotec,DC=xyz'
$DomainDN = "DC=ad,DC=evotec,DC=xyz"
$AdministrativeUnit = 'FR_IT_Team02'
$Groups = @{
    "DL_Tier2_PUIDs_A_$AdministrativeUnit"                 = @{
        Path          = "OU=Administration_Tasks_Groups,OU=Administration,$DomainDN"
        GroupScope    = 'DomainLocal'
        GroupCategory = 'Security'
        Description   = 'Testing '
        DisplayName   = "DL_Tier2_PUIDs_A_$AdministrativeUnit"
    }
    "DL_Tier2_Groups_A_$AdministrativeUnit"                = @{
        Path          = "OU=Administration_Tasks_Groups,OU=Administration,$DomainDN"
        GroupScope    = 'DomainLocal'
        GroupCategory = 'Security'
    }
    "DL_Tier2_Contacts_A_$AdministrativeUnit"              = @{
        Path          = "OU=Administration_Tasks_Groups,OU=Administration,$DomainDN"
        GroupScope    = 'DomainLocal'
        GroupCategory = 'Security'
    }
    "DL_Tier2_Computers_A_$AdministrativeUnit"             = @{
        Path          = "OU=Administration_Tasks_Groups,OU=Administration,$DomainDN"
        GroupScope    = 'DomainLocal'
        GroupCategory = 'Security'
    }
    "DL_Tier2_LAPS_A_Administrator_$AdministrativeUnit"    = @{
        Path          = "OU=Administration_Tasks_Groups,OU=Administration,$DomainDN"
        GroupScope    = 'DomainLocal'
        GroupCategory = 'Security'
    }
    "DL_Tier2_User_Account_B_$AdministrativeUnit"          = @{
        Path          = "OU=Administration_Tasks_Groups,OU=Administration,$DomainDN"
        GroupScope    = 'DomainLocal'
        GroupCategory = 'Security'
    }
    "DL_Tier2_Groups_B_$AdministrativeUnit"                = @{
        Path          = "OU=Administration_Tasks_Groups,OU=Administration,$DomainDN"
        GroupScope    = 'DomainLocal'
        GroupCategory = 'Security'
    }
    "GG_Tier2_Multiple_Objects_Admins_$AdministrativeUnit" = @{
        Path          = "OU=Groups,OU=Administration,$DomainDN"
        Name          = "GG_Tier2_Multiple_Objects_Admins_$AdministrativeUnit"
        GroupScope    = 'Global'
        GroupCategory = 'Security'
        Members       = @(
            'przemyslaw.klys'
        )
        MemberOf      = @(
            "DL_Tier2_PUIDs_A_$AdministrativeUnit"
            "DL_Tier2_Groups_A_$AdministrativeUnit"
            "DL_Tier2_Contacts_A_$AdministrativeUnit"
            "DL_Tier2_Computers_A_$AdministrativeUnit"
            "DL_Tier2_LAPS_A_Administrator_$AdministrativeUnit"
        )
    }
    "GG_Tier2_Service_Desk_Admins"                         = @{
        Path          = 'OU=Groups,OU=Administration,DC=ad,DC=evotec,DC=xyz'
        Name          = "GG_Tier2_Service_Desk_Admins"
        GroupScope    = 'Global'
        GroupCategory = 'Security'
        Members       = @()
        MemberOf      = @(
            "DL_Tier2_User_Account_B_$AdministrativeUnit"
            "DL_Tier2_Groups_B_$AdministrativeUnit"
        )
    }
    "GG_Tier2_LDAP_Admins_$AdministrativeUnit"             = @{
        Path          = 'OU=Groups,OU=Administration,DC=ad,DC=evotec,DC=xyz'
        Name          = "GG_Tier2_LDAP_Admins_$AdministrativeUnit"
        GroupScope    = 'Global'
        GroupCategory = 'Security'
        Members       = @()
        MemberOf      = @(
            "DL_Tier2_LAPS_A_Administrator_$AdministrativeUnit"
        )
    }
}

Start-DelegationGroups -Destination $Destination -Domain 'ad.evotec.xyz' -Groups $Groups -Verbose