Import-Module .\DelegationModel.psd1 -Force

# Where do you want to save created groups, when there's no Path defined
$Destination = 'OU=Delegation,OU=Groups,OU=Production,DC=ad,DC=evotec,DC=xyz'
# Which domain you want to create groups
$Domain = 'ad.evotec.xyz'
$DomainDN = "DC=ad,DC=evotec,DC=xyz"
# Administrative Unit you want to create groups for
$AdministrativeUnit = 'FR_IT_Team08'
# Groups to create
$Groups = @{
    "DL_Tier2_PUIDs_A_$AdministrativeUnit"                 = @{
        # moving a group feature
        Path                            = "OU=Administration_Tasks_Groups,OU=Administration,$DomainDN"
        GroupScope                      = 'DomainLocal'
        GroupCategory                   = 'Security'
        Description                     = 'Testing description'
        DisplayName                     = "DL_Tier2_PUIDs_A_$AdministrativeUnit"
        ProtectedFromAccidentalDeletion = $false
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
    "DL_Tier2_Devices_$AdministrativeUnit"                 = @{
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
    "GG_Tier2_Multiple_Objects_Admins_$AdministrativeUnit" = @{
        Path          = "OU=Groups,OU=Administration,$DomainDN"
        Name          = "GG_Tier2_Multiple_Objects_Admins_$AdministrativeUnit"
        GroupScope    = 'Global'
        GroupCategory = 'Security'
        Members       = @(
            #'przemyslaw.klys'
            'dennis.vanburen'
        )
        MembersBehaviour = 'Add' #,'Remove'
        MemberOf      = @(
            "DL_Tier2_PUIDs_A_$AdministrativeUnit"
            "DL_Tier2_Groups_A_$AdministrativeUnit"
            "DL_Tier2_Contacts_A_$AdministrativeUnit"
            "DL_Tier2_Computers_A_$AdministrativeUnit"
            "DL_Tier2_LAPS_A_Administrator_$AdministrativeUnit"
        )
    }
}

Start-DelegationGroups -Destination $Destination -Domain $Domain -Groups $Groups -Verbose