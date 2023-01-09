Import-Module .\DelegationModel.psd1 -Force

# Similar to Examples\01-CreateGroups01.ps1 - Alternative way to create/manage groups
$AdministrativeUnits = 'FR_IT_Team08', 'FR_IT_Team09', 'FR_IT_Team06'
$DomainDN = "DC=ad,DC=evotec,DC=xyz"
$OUPath = "OU=Administration_Tasks_Groups,OU=Administration,$DomainDN"

Start-DelegationGroups -MembersBehaviour 'Add', 'Remove' -Destination 'OU=Delegation,OU=Groups,OU=Production,DC=ad,DC=evotec,DC=xyz' -Domain 'ad.evotec.xyz' -Verbose {
    foreach ($AdministrativeUnit in $AdministrativeUnits) {
        New-DelegationGroup -Name "DL_Tier2_PUIDs_A_$AdministrativeUnit" -Path $OUPath -GroupScope 'DomainLocal' -GroupCategory 'Security' -Description 'Testing description 1' -DisplayName "DL_Tier2_PUIDs_A_$AdministrativeUnit" -ProtectedFromAccidentalDeletion $false
        New-DelegationGroup -Name "DL_Tier2_Groups_A_$AdministrativeUnit" -Path $OUPath -GroupScope 'DomainLocal' -GroupCategory 'Security'
        New-DelegationGroup -Name "DL_Tier2_Contacts_A_$AdministrativeUnit" -Path $OUPath -GroupScope 'DomainLocal' -GroupCategory 'Security'
        New-DelegationGroup -Name "DL_Tier2_Computers_A_$AdministrativeUnit" -Path $OUPath -GroupScope 'DomainLocal' -GroupCategory 'Security'
        New-DelegationGroup -Name "DL_Tier2_Devices_$AdministrativeUnit" -Path $OUPath -GroupScope 'DomainLocal' -GroupCategory 'Security'
        New-DelegationGroup -Name "DL_Tier2_LAPS_A_Administrator_$AdministrativeUnit" -Path $OUPath -GroupScope 'DomainLocal' -GroupCategory 'Security'
        New-DelegationGroup -Name "DL_Tier2_User_Account_B_$AdministrativeUnit" -Path $OUPath -GroupScope 'DomainLocal' -GroupCategory 'Security'
        New-DelegationGroup -Name "DL_Tier2_Groups_B_$AdministrativeUnit" -Path $OUPath -GroupScope 'DomainLocal' -GroupCategory 'Security'
        New-DelegationGroup -Name "DL_Tier2_Contacts_B_$AdministrativeUnit" -Path $OUPath -GroupScope 'DomainLocal' -GroupCategory 'Security'
        New-DelegationGroup -Name "DL_Tier2_Computers_B_$AdministrativeUnit" -Path $OUPath -GroupScope 'DomainLocal' -GroupCategory 'Security'
        New-DelegationGroup -Name "DL_Tier2_Devices_$AdministrativeUnit" -Path $OUPath -GroupScope 'DomainLocal' -GroupCategory 'Security'
        New-DelegationGroup -Name "DL_Tier2_LAPS_B_Administrator_$AdministrativeUnit" -Path $OUPath -GroupScope 'DomainLocal' -GroupCategory 'Security'
        New-DelegationGroup -Name "DL_Tier2_OU_$AdministrativeUnit" -Path $OUPath -GroupScope DomainLocal -GroupCategory Security
        New-DelegationGroup -Name "DL_Tier2_UserVIP_$AdministrativeUnit" -Path $OUPath -GroupScope DomainLocal -GroupCategory Security
        New-DelegationGroup -Name "DL_Tier2_User_$AdministrativeUnit" -Path $OUPath -GroupScope DomainLocal -GroupCategory Security
        New-DelegationGroup -Name "DL_Tier2_Groups_$AdministrativeUnit" -Path $OUPath -GroupScope DomainLocal -GroupCategory Security
        New-DelegationGroup -Name "DL_Tier2_RSOP_$AdministrativeUnit" -Path $OUPath -GroupScope DomainLocal -GroupCategory Security
        New-DelegationGroup -Name "DL_Tier2_PWDMgmt_$AdministrativeUnit" -Path $OUPath -GroupScope DomainLocal -GroupCategory Security
        New-DelegationGroup -Name "DL_Tier2_DevicesLAPSRead_$AdministrativeUnit" -Path $OUPath -GroupScope DomainLocal -GroupCategory Security
        New-DelegationGroup -Name "DL_Tier2_DevicesVIPLAPSRead_$AdministrativeUnit" -Path $OUPath -GroupScope DomainLocal -GroupCategory Security
        New-DelegationGroup -Name "DL_Tier2_DevicesVIP_$AdministrativeUnit" -Path $OUPath -GroupScope DomainLocal -GroupCategory Security
        New-DelegationGroup -Name "DL_Tier2_Instruments_$AdministrativeUnit" -Path $OUPath -GroupScope DomainLocal -GroupCategory Security
        New-DelegationGroup -Name "DL_Tier2_InstrumentsLAPSRead_$AdministrativeUnit" -Path $OUPath -GroupScope DomainLocal -GroupCategory Security
        New-DelegationGroup -Name "GG_Tier2_Service_Desk_Admins" -Path $OUPath -GroupScope 'DomainLocal' -GroupCategory 'Security' -Members @(
            # add members if needed
        ) -MemberOf @(
            "DL_Tier2_User_Account_B_$AdministrativeUnit"
            "DL_Tier2_Groups_B_$AdministrativeUnit"
        )
        New-DelegationGroup -Name "GG_Tier2_LDAP_Admins_$AdministrativeUnit" -Path $OUPath -GroupScope 'DomainLocal' -GroupCategory 'Security' -Members @(
            # add members if needed
        ) -MemberOf @(
            "DL_Tier2_LAPS_A_Administrator_$AdministrativeUnit"
        )
        $newDelegationGroupSplat = @{
            Name          = "GG_Tier2_Multiple_Objects_Admins_$AdministrativeUnit"
            Path          = $OUPath
            GroupScope    = 'DomainLocal'
            GroupCategory = 'Security'
            Members       = @(
                #'przemyslaw.klys'
                'dennis.vanburen'
            )
            MemberOf      = @(
                "DL_Tier2_PUIDs_A_$AdministrativeUnit"
                "DL_Tier2_Groups_A_$AdministrativeUnit"
                "DL_Tier2_Contacts_A_$AdministrativeUnit"
                "DL_Tier2_Computers_A_$AdministrativeUnit"
                "DL_Tier2_LAPS_A_Administrator_$AdministrativeUnit"
            )
        }
        New-DelegationGroup @newDelegationGroupSplat -MembersBehaviour 'Add', 'Remove'
    }
} -LogOption Add, Remove